#include "kernel/types.h"
#include "kernel/param.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

#define MAX_STDIN_SIZE 2048
#define STDIN_FILENO 0

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

void execCommand(char** argv) {
    int pid = fork();
    if (pid < 0) {
        printf("Error: Fork Failed.\n");
        exit(ERROR);
    } else if (pid == 0) {
        // printf("EXEC: ('%s', '%s', '%s')\n", argv[0], argv[1], argv[2]);
        exec(argv[0], argv);
        exit(SUCCESS);
    } else wait(&pid);
}

// char* getLine(char** buffPtr) {
//     printf("%p, %d %s\n", *buffPtr, strlen(*buffPtr), *buffPtr);
//     if (strlen(*buffPtr) == 0) return 0;
//     char* buff = *buffPtr;
//     char* newlinePtr = strchr(buff, '\n');

//     // Close the found str and move to the next segment.
//     if (newlinePtr != 0) {
//         *newlinePtr = 0;
//         *buffPtr = newlinePtr + 1;
//     }

//     printf("Res PTR: %p [%d] '%s'\n", *buffPtr, strlen(*buffPtr), *buffPtr);
//     return buff;
// }

int main(int argc, char* argv[])
{
    // printf("Command (%d): '%s'\n", argc, argv[COMMAND]);
    char buff[MAX_STDIN_SIZE] = {0};
    // char* buffPtr = buff;
    // read(STDIN_FILENO, buff, MAX_STDIN_SIZE);
    // printf("Read string of size [%d]: '%s'\n", strlen(buffPtr), buffPtr);

    if (argc < MIN_ARGC) {
        printf("No command given.\n");
        exit(ERROR);
    } else if(!isFile(argv[COMMAND])) {
        printf("'%s' is not a valid command (file not found).\n", argv[COMMAND]);
        exit(ERROR);
    }

    char* command[MAXARG];
    char* line = 0;
    while ((strlen(gets(buff, MAX_STDIN_SIZE)) /*line = getLine(&buffPtr)*/) != 0) {
        line = buff;
        line[strlen(line) - 1] = 0;
        // printf("Got Line: '%s'\n", line);
        int arg;
        for (arg = 0; arg < argc - COMMAND; arg++) {
            // printf("Setting %d to %d (%s)\n", arg, COMMAND+arg, argv[COMMAND + arg]);
            command[arg] = argv[COMMAND + arg];
            // printf("Command(%d): %s\n", arg, command[arg]);
        }
        // printf("Setting arg: %d\n", arg);
        command[arg] = line;
        // printf("COMMAND: ('%s', '%s', '%s')\n", command[0], command[1], command[2]);
        execCommand(command);
    }

    exit(SUCCESS);
}
