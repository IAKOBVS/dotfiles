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

#define NAMESZ (sizeof(size_t) * 8)
#define LINESZ 1024

#define TMP_DIR_ENV "/tmp/__GLOBAL_FZFVIM__"
#define FNAME_START "/proc/"
#define FNAME_END   "/status"

#define SLEEP_TIME (900)

#define CHK(cond, string)                                     \
	do {                                                  \
		if (!(cond)) {                                \
			err(TMP_DIR_ENV "/err", string, strlen(string)); \
			assert(0);                            \
		}                                             \
	} while (0)

char *
xstpcpy_len(char *dst, const char *src, size_t n)
{
	dst = (char *)memcpy(dst, src, n) + n;
	*dst = '\0';
	return dst;
}

void
err(const char *errorfile, const char *err_string, unsigned int err_string_len)
{
	char *err = strerror(errno);
	DEBUG_PRINT("%s:%s:%s\n", errorfile, err, err_string);
	unsigned int err_len = strlen(err);
	char buf[4096];
	char *p = xstpcpy_len(buf, err, err_len);
	p = xstpcpy_len(p, err_string, err_string_len);
	*p = '\0';
	int fd = open(errorfile, O_APPEND | O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	assert(fd != -1);
	assert(write(fd, buf, (size_t)(p - buf)) == (p - buf));
	fd = close(fd);
	assert(fd != -1);
	exit(EXIT_FAILURE);
}

void
process(void)
{
	DEBUG_PRINT("err_file:%s\n", TMP_DIR_ENV "/err");
	/* Require tmp_dir */
	const char *tmp_dir = TMP_DIR_ENV;
	assert(tmp_dir);
	/* Require /proc/ */
	CHK(access(FNAME_START, F_OK) == 0, "");
	DEBUG_PRINT("tmp_dir:%s\n", tmp_dir);
	/* cd to tmp_dir and open directory */
	CHK(chdir(tmp_dir) == 0, "");
	char fname[NAMESZ + S_LEN(FNAME_END) + 1];
	strcpy(fname, FNAME_START);
	for (;;) {
		DIR *dp = opendir(".");
		assert(dp);
		struct dirent *ep;
		/* Loop over files in /tmp/__GLOBAL_FZFVIM__ */
		while ((ep = readdir(dp))) {
			if (unlikely(*(ep->d_name) == '.')
			    || (unlikely(*(ep->d_name) != '_') && unlikely(*(ep->d_name + 1) != '_')))
				continue;
			const char *pid = strstr(ep->d_name + 2, "__");
			if (unlikely(pid == NULL))
				continue;
			pid += 2;
			strcpy(fname + S_LEN(FNAME_START), pid);
			DEBUG_PRINT("pid:%s\n", pid);
			DEBUG_PRINT("fname:%s\n", fname);
			/* Check if file in /tmp/__GLOBAL_FZFVIM__ a process. */
			if (access(fname, F_OK) == -1)
				DEBUG_PRINT("fname_is_process:%s\n", fname);
				/* It is not. Do cleanup. */
				CHK(unlink(ep->d_name) == 0, "");
		}
		CHK(closedir(dp) == 0, "");
		DEBUG_PRINT("%s\n", "sleeping...");
		sleep(SLEEP_TIME);
	}
}

int
main()
{
	process();
	return 0;
}
