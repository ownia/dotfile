#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	DIR * dir;
	struct dirent * ptr;
	int i;

	dir = opendir(argv[1]);
	while((ptr = readdir(dir)) != NULL) {
		printf("d_name %s d_ino %ld d_off %ld\n", ptr->d_name, ptr->d_ino, ptr->d_off);
	}

	closedir(dir);
}
