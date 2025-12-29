#define DEBUG 0

#include <dirent.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

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

#define TMP_DIR_ENV "__GLOBAL_FZFVIM__"
#define FNAME_START "/proc/"
#define FNAME_END   "/status"

#define SLEEP_TIME (900)

void process(void)
{
	/* Require /proc/ */
	assert(access(FNAME_START, F_OK) == 0);
	/* Require tmp_dir */
	const char *tmp_dir = getenv(TMP_DIR_ENV);
	assert(tmp_dir);
	DEBUG_PRINT("tmp_dir:%s\n", tmp_dir);
	/* cd to tmp_dir and open directory */
	assert(chdir(tmp_dir) == 0);
	DIR *dp = opendir(".");
	assert(dp);
	struct dirent *ep;
	char fname[NAMESZ + S_LEN(FNAME_END) + 1];
	strcpy(fname, FNAME_START);
	for (;;) {
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
				/* It is not. Do cleanup. */
				assert(unlink(ep->d_name) == 0);
		}
		closedir(dp);
		sleep(SLEEP_TIME);
	}
}

int
main()
{
	process();
	return 0;
}
