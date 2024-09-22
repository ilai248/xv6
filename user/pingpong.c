#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "sys/syscall.h"

#define PRINTF_SYNC_SLEEP_DURATION 2
#define PIPE_SIZE 2
#define SINGLE_BYTE 1
// #define DEBUG

enum PipeIndexes {PIPE_READ, PIPE_WRITE};
enum ReturnCodes {SUCCESS, ERROR};

/*
Handle the case where the current process is the parent process -
send byte to child (who has the given pid), then receive a byte from the child.
*/
void handle_parent(int child_fd[], int parent_fd[], int child_pid) {
    char buff[SINGLE_BYTE+1] = {0};

    // No nead to read from the child pipe or write to the parent pipe so we close those ports.
    close(child_fd[PIPE_READ]);
    close(parent_fd[PIPE_WRITE]);

    // Ping the child process with a single byte.
    write(child_fd[PIPE_WRITE], ".", SINGLE_BYTE);
    int bytesRead = read(parent_fd[PIPE_READ], buff, SINGLE_BYTE);
    
    // Wait a bit in order to sync the child's printf with the parent's prints.
    wait(&child_pid);
    
    // Check the case where no bytes were read.
    if (bytesRead <= 0) {
        printf("Error reading received bytes (Parent)\n");
        exit(ERROR);
    }

    // Print some info about the received byte if we are in debug mode
#ifdef DEBUG
    printf("\nParent Received (%d): '%s'\n", bytesRead, buff);
#endif
    printf("%d: received pong\n", getpid());
    exit(SUCCESS);
}

/*
Handle the case where the current process is the child process -
Receive a byte from the parent and send one in return.
*/
void handle_child(int child_fd[], int parent_fd[]) {
    char buff[SINGLE_BYTE+1] = {0};

    // No nead to read from the parent pipe or write to the child pipe so we close those ports.
    close(parent_fd[PIPE_READ]);
    close(child_fd[PIPE_WRITE]);

    // Receive a byte from the parent.
    int bytesRead = read(child_fd[PIPE_READ], buff, SINGLE_BYTE);

    // Check the case where no bytes were read.
    if (bytesRead <= 0) {
        printf("Error reading received bytes (Child)\n");
        exit(ERROR);
    }

    // Print some info about the received byte if we are in debug mode
#ifdef DEBUG
    printf("Child Received (%d): '%s'\n", bytesRead, buff);
#endif
    printf("%d: received ping\n", getpid());

    // Write a byte back to the parent.
    write(parent_fd[PIPE_WRITE], ".", SINGLE_BYTE);
    exit(SUCCESS);
}

int main(int argc, char *argv[])
{
    int child_fd[PIPE_SIZE], parent_fd[PIPE_SIZE];

    // Attempt to create the child pipe.
    if (pipe(child_fd) != 0) {
        printf("Error creating child pipe\n");
        exit(ERROR);
    }

    // Attempt to create the parent pipe.
    if (pipe(parent_fd) != 0) {
        printf("Error creating parent pipe\n");
        exit(ERROR);
    }

    int pid = fork();
    // Check for fork error.
    if (pid < 0) {
        printf("Error forking process\n");
        exit(ERROR);
    } else if (pid > 0) handle_parent(child_fd, parent_fd, pid);
    else handle_child(child_fd, parent_fd);
}
