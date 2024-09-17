#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

#define BUFF_SIZE 100
#define MAX_DIRECTORIES 20

#define bool int
#define true 1
#define false 0

enum Args {DIR_PATH=1, FILE_NAME};
enum ReturnCodes {SUCCESS, ERROR};

char* filename(char* path)
{
  static char buf[DIRSIZ+1];
  char* fileName;

  // Find first character after last slash.
  for (fileName = path+strlen(path); fileName >= path && *fileName != '/'; fileName--);
  fileName++;

  // Return the file's name.
  if(strlen(fileName) >= DIRSIZ)
    return fileName;
  memmove(buf, fileName, strlen(fileName));
  buf[strlen(fileName)] = 0;
  return buf;
}

bool isFile(char* path) {
    int fd;
    struct stat st;

    if ((fd = open(path, O_RDONLY)) < 0) {
        fprintf(2, "find: cannot open %s\n", path);
        return false;
    }

    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return false;
    }

    close(fd);
    return st.type == T_FILE || st.type == T_DEVICE;
}

bool find(char* path, char* fileName)
{
  char* p;
  int fd;
  struct dirent de;
  struct stat st;
    bool res = false;
    char dirs[BUFF_SIZE][MAX_DIRECTORIES];

    // Open the entry in the given path.
    if ((fd = open(path, O_RDONLY)) < 0) {
    fprintf(2, "find: cannot open %s\n", path);
    return false;
    }

    // Get the current entry's stats (and check its type).
    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return false;
    }

    switch (st.type) {
        case T_DEVICE:
        case T_FILE:
            char* actualFileName = filename(path);
            if (!strcmp(actualFileName, fileName)) {
                printf("%s\n", path);
                res = true;
            }
            close(fd);
            return res;

        case T_DIR:
            if(strlen(path) + 1 + DIRSIZ + 1 > BUFF_SIZE){
                printf("find: path too long\n");
                break;
            }

            int i = 0;
            while (read(fd, &de, sizeof(de)) == sizeof(de)) {
                if(de.inum == 0) continue;

                // Skip '.' and '..' directories.
                if (!strcmp(de.name, ".") || !strcmp(de.name, "..")) continue;

                // Get the current entry's path.
                strcpy(dirs[i], path);
                p = dirs[i] + strlen(dirs[i]);
                *p++ = '/';
                memmove(p, de.name, DIRSIZ);
                p[DIRSIZ] = 0;

                // Check if we found the searched file.
                if (isFile(dirs[i])) {
                    char* actualFileName = filename(dirs[i]);
                    if (!strcmp(actualFileName, fileName)) {
                        printf("%s\n", dirs[i]);
                        res = true;
                    }
                    dirs[i][0] = 0;
                } else ++i; // Save the dir's name in order to iterate on it later.
            }
            break;
    }

    // Continue searching inner directories as DFS.
    for (int i = 0; i < MAX_DIRECTORIES; i++) {
        if (strlen(dirs[i]) == 0) break;
        res |= find(dirs[i], fileName);
    }

    close(fd);
    return res;
}

int main(int argc, char *argv[])
{
    // Get file name to find.
    if (argc < FILE_NAME){
        printf("Invalid call format\n");
        exit(ERROR);
    }

    // Get directory to start searching from.
    if (!find(argv[DIR_PATH], argv[FILE_NAME])) {
        printf("Couldn't find file\n");
        exit(ERROR);
    }
    exit(SUCCESS);
}
