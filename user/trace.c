#include "kernel/types.h"
#include "kernel/param.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

#define bool int
#define true 1
#define false 0

enum ArgvIndexes {PROGRAM_NAME_INDEX, SYSCALL_MASK, COMMAND};
enum ReturnCodes {SUCCESS, ERROR};

bool isFile(char* path) {
    int fd;
    struct stat st;

    if ((fd = open(path, O_RDONLY)) < 0) {
        fprintf(2, "Cannot Open %s\n", path);
        return false;
    }

    if (fstat(fd, &st) < 0) {
        fprintf(2, "Cannot Stat %s\n", path);
        close(fd);
        return false;
    }

    close(fd);
    return st.type == T_FILE || st.type == T_DEVICE;
}

int main(int argc, char* argv[]) {
    // Ensure correct argc (valid args count).
    if (argc < COMMAND + 1 ){
        printf("Wrong Format. Correct Format is:\n\t%s %s", argv[PROGRAM_NAME_INDEX], "<Syscall Mask> <Command>\n");
        exit(ERROR);
    } else if(!isFile(argv[COMMAND])) {
        printf("'%s' is not a valid command (file not found).\n", argv[COMMAND]);
        exit(ERROR);
    }

    int syscallMask = atoi(argv[SYSCALL_MASK]);
    if (syscallMask < 0) {
        printf("Error: Syscall Mask cannot be a negative integer.\n");
        exit(ERROR);
    }

    // The argv of the command we want to send is at argv + the command's name index.
    trace(syscallMask);
    exec(argv[COMMAND], argv + COMMAND);
    exit(SUCCESS);
}
