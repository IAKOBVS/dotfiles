/* SPDX-License-Identifier: MIT */
/* Copyright (c) 2026 James Tirta Halim <tirtajames45 at gmail dot com>
 * This file is part of IAKOBVS/dotfiles.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE. */

#define DEBUG 0

#include <dirent.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

#ifdef __GLIBC_PREREQ
#	define JSTR_GLIBC_PREREQ(maj, min) __GLIBC_PREREQ(maj, min)
#elif defined __GLIBC__
#	define JSTR_GLIBC_PREREQ(maj, min) ((__GLIBC__ << 16) + __GLIBC_MINOR__ >= ((maj) << 16) + (min))
#endif

#if (defined __GLIBC__ && JSTR_GLIBC_PREREQ(2, 10) && (_POSIX_C_SOURCE - 0) >= 200809L) \
|| defined _GNU_SOURCE
#	define HAVE_STPCPY 1
#endif

#ifdef __glibc_has_builtin
#	define JSTR_HAS_BUILTIN(name) __glibc_has_builtin(name)
#elif defined __has_builtin
#	define JSTR_HAS_BUILTIN(name) __has_builtin(name)
#endif /* has_builtin */
#if defined __glibc_unlikely && defined __glibc_likely
#	define likely(x)   __glibc_likely(x)
#	define unlikely(x) __glibc_unlikely(x)
#elif (defined __GNUC__ && (__GNUC__ >= 3)) || defined __clang__
#	if JSTR_HAS_BUILTIN(__builtin_expect)
#		define likely(x)   __builtin_expect((x), 1)
#		define unlikely(x) __builtin_expect((x), 0)
#	endif
#endif

#if DEBUG
#	define DEBUG_PRINT(fmt, ...) (printf(fmt, __VA_ARGS__))
#else
#	define DEBUG_PRINT(fmt, ...)
#endif

#define S_LEN(s) (sizeof(s) - (1))

#define PIDLEN (sizeof(size_t) * 8)
#define LINESZ 1024

#define TMPDIR_ENV  "JPROC_DIR"
#define FNAME_START "/proc/"
#define FNAME_END   "/status"

#define SLEEP_TIME (900)

#ifndef NAME_MAX
#	define NAME_MAX 256
#endif

#define CHK(cond, string)                                    \
	do {                                                 \
		if (!(cond)) {                               \
			err("/err", string, strlen(string)); \
			assert(0);                           \
		}                                            \
	} while (0)

char *
xstpcpy_len(char *dst, const char *src, size_t n)
{
	dst = (char *)memcpy(dst, src, n) + n;
	*dst = '\0';
	return dst;
}

char *
xstpcpy(char *d, const char *s)
{
#if HAVE_STPCPY
	return stpcpy(d, s);
#else
	return xstpcpy_len(d, s, strlen(s));
#endif
}

void
err(const char *tmpdir, const char *err_string, unsigned int err_string_len)
{
	char *err = strerror(errno);
	const char *errorfile = "stderr";
	DEBUG_PRINT("%s:%s:%s:%s\n", tmpdir, errorfile, err, err_string);
	unsigned int err_len = strlen(err);
	char buf[4096];
	char *p = xstpcpy_len(buf, err, err_len);
	p = xstpcpy_len(p, err_string, err_string_len);
	*p = '\0';
	assert(chdir(tmpdir) == 0);
	assert(write(STDERR_FILENO, buf, (size_t)(p - buf)) == (p - buf));
	exit(EXIT_FAILURE);
	(void)errorfile;
}

#define ISDIGIT(x) (((x) > '0' - 1) && (x) < '9' + 1)

char *
aredigits_p(const char *s)
{
	for (; ISDIGIT(*s); ++s) {}
	return *s == '\0' ? (char *)s : NULL;
}

int
rm_rf(const char *dir, size_t dir_len)
{
	char path[PIDLEN * 8 + NAME_MAX];
	/* Construct [pid] */
	char *path_p = xstpcpy_len(path, dir, dir_len);
	/* Construct [pid]/ */
	path_p = xstpcpy_len(path_p, "/", S_LEN("/"));
	DIR *dp = opendir(dir);
	CHK(dp, "");
	struct dirent *ep;
	while ((ep = readdir(dp))) {
		if (*(ep->d_name) == '.')
			continue;
		/* Construct [pid]/[file] */
		strcpy(path_p, ep->d_name);
		DEBUG_PRINT("path_to_file_remove:%s\n", path);
		CHK(unlink(path) == 0, "");
	}
	CHK(closedir(dp) == 0, "");
	return 0;
}

void
process(void)
{
	/* Require tmpdir */
	const char *tmpdir = getenv(TMPDIR_ENV);
	assert(tmpdir);
	/* Require /proc/ */
	CHK(access(FNAME_START, F_OK) == 0, "");
	DEBUG_PRINT("tmpdir:%s\n", tmpdir);
	/* cd to tmpdir and open directory */
	CHK(chdir(tmpdir) == 0, "");
	char fname[S_LEN(FNAME_START) + PIDLEN + S_LEN(FNAME_END) + 1];
	char *fname_pid = xstpcpy_len(fname, FNAME_START, S_LEN(FNAME_START));
	DIR *dp = opendir(".");
	assert(dp);
	struct dirent *ep;
	char *d_namep;
	/* Loop over files in /tmp/$JPROC_DIR */
	while ((ep = readdir(dp))) {
		/* Only go over /tmp/$JPROC_DIR/[pid] */
		d_namep = aredigits_p(ep->d_name);
		if (d_namep == NULL)
			continue;
		xstpcpy_len(fname_pid, ep->d_name, (size_t)(d_namep - ep->d_name));
		DEBUG_PRINT("pid:%s\n", ep->d_name);
		DEBUG_PRINT("fname:%s\n", fname);
		/* Check /proc/[pid] if file in /tmp/JPROC_DIR/[pid] a process. */
		if (access(fname, F_OK) == -1) {
			DEBUG_PRINT("fname_is_process:%s\n", fname);
			rm_rf(ep->d_name, (size_t)(d_namep - ep->d_name));
			DEBUG_PRINT("dir_to_remove:%s\n", ep->d_name);
			/* If not, remove /tmp/JPROC_DIR/[pid]. */
			CHK(rmdir(ep->d_name) == 0, "");
		}
	}
	CHK(closedir(dp) == 0, "");
}

int
main()
{
	process();
	return 0;
}
