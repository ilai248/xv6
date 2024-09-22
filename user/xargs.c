#include "kernel/types.h"
#include "kernel/param.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

#define MAX_LINE_SIZE 200

#define bool int
#define true 1
#define false 0
#define MIN_ARGC 2

enum ArgvIndexes {COMMAND=1};
enum ReturnCodes {SUCCESS, ERROR};

bool isFile(char* path) {
    int fd;
    struct stat st;

    if ((fd = open(path, O_RDONLY)) < 0) {
        fprintf(2, "xargs: cannot open %s\n", path);
        return false;
    }

    if (fstat(fd, &st) < 0) {
        fprintf(2, "xargs: cannot stat %s\n", path);
        close(fd);
        return false;
    }

    close(fd);
    return st.type == T_FILE || st.type == T_DEVICE;
}

void execCommand(char** argv) {
    int pid = fork();
    if (pid < 0) {
        printf("Error: Fork Failed.\n");
        exit(ERROR);
    } else if (pid == 0) {
        exec(argv[0], argv);
        exit(SUCCESS);
    } else wait(&pid);
}

int main(int argc, char* argv[])
{
    char line[MAX_LINE_SIZE] = {0};

    if (argc < MIN_ARGC) {
        printf("No command given.\n");
        exit(ERROR);
    } else if(!isFile(argv[COMMAND])) {
        printf("'%s' is not a valid command (file not found).\n", argv[COMMAND]);
        exit(ERROR);
    }

    char* command[MAXARG];
    while ((strlen(gets(line, MAX_LINE_SIZE))) != 0) {
        // Remove the received '\n'.
        line[strlen(line) - 1] = 0;
        int arg;
        for (arg = 0; arg < argc - COMMAND; arg++)
            command[arg] = argv[COMMAND + arg];
        command[arg] = line;
        execCommand(command);
    }

    exit(SUCCESS);
}
