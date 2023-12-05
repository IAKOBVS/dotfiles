#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int
aredigits(const char *s)
{
	const unsigned char *p;
	p = (const unsigned char *)s;
	if (*p == '\0')
		return -1;
	for (; *p; ++p)
		if (!isdigit(*p))
			return 0;
	return 1;
}

size_t
handle(const char *s)
{
	size_t ret;
	ret = aredigits(s);
	switch (ret) {
	case 0:
		assert(s[1] == '\0');
		ret = *s;
		break;
	case 1:
		ret = strtol(s, NULL, 10);
		assert(errno != EINVAL);
		break;
	case -1:
		puts(strerror(errno));
		exit(EXIT_FAILURE);
		break;
	}
	return ret;
}

int
main(int argc,
     char **argv)
{
	assert(argv[1] && argv[1][0]);
	size_t i, j;
	i = handle(argv[1]);
	if (argv[2] == NULL)
		j = 256;
	else
		j = handle(argv[2]);
	for (; i <= j; ++i)
		if (i < 256 && isprint(i)) {
			if (i == '\\' || i == '\'')
				printf("'\\%c'\n", (char)i);
			else if (i == '\n')
				puts("'\\n'");
			else if (i == '\v')
				puts("'\\v'");
			else if (i == '\f')
				puts("'\\f'");
			else if (i == '\r')
				puts("'\\r'");
			else
				printf("'%c'\n", (char)i);
		} else {
			printf("%zu\n", i);
		}
	return EXIT_SUCCESS;
}
