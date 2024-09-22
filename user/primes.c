#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "sys/syscall.h"

#define NULL 0
#define PIPE_SIZE 2
#define MIN_PIPELINE_VAL 2
#define MAX_PIPELINE_VAL 35
#define EXIT_SIGNAL -1
#define SLEEP_DELAY_BETWEEN_NUMS 1

#define bool int
#define false 0
#define true 1
// #define DEBUG

enum PipeIndexes {PIPE_READ, PIPE_WRITE};
enum ReturnCodes {SUCCESS, ERROR};

inline void send_num(int num, int fd_array[]) {
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
}

inline int recv_num(int* fd_array) {
    int num = 0; 
    
    // Attempt to read the current num (and check the case where no bytes were read).
    if (read(fd_array[PIPE_READ], &num, sizeof(int)) <= 0) {
        printf("Error reading received bytes (Parent)\n");
        exit(ERROR);
    }
    return num;
}

int* new_pipe() {
    int* fd = (int*)malloc(sizeof(int) * PIPE_SIZE);

    // Attempt to create the child pipe.
    if (pipe(fd) != 0) {
        printf("Error creating child pipe\n");
        exit(ERROR);
    }
    return fd;
}

void handle_parent(int* first_fd, int child_pid) {
    close(first_fd[PIPE_READ]);

    // Send the next process's number to it.
    send_num(MIN_PIPELINE_VAL, first_fd);

    // Write all numbers from 2 to 35 to the pipeline.
    for (int i = MIN_PIPELINE_VAL; i <= MAX_PIPELINE_VAL; i++) {
        send_num(i, first_fd);
        sleep(SLEEP_DELAY_BETWEEN_NUMS);
    }

    // Send shutdown signal to the child.
    send_num(EXIT_SIGNAL, first_fd);

    // Wait for the child to exit.
    wait(&child_pid);

    // Close the pipe.
    close(first_fd[PIPE_WRITE]);
    free(first_fd);
    exit(SUCCESS);
}

void handle_child(int* parent_fd) __attribute__((noreturn));
void handle_child(int* parent_fd) {
    int recv_num = 0;
    int* next_fd = NULL;
    int my_num = 0;
    int new_pid = -1;

    close(parent_fd[PIPE_WRITE]);

    // Attempt to read the current num (and check the case where no bytes were read).
    if (read(parent_fd[PIPE_READ], &my_num, sizeof(int)) <= 0) {
        printf("Error reading received bytes\n");
        exit(ERROR);
    }
    printf("prime %d\n", my_num);

    // Handle received numbers and check if the current number divides them.
    while (true) {
        // Attempt to read the current num (and check the case where no bytes were read).
        if (read(parent_fd[PIPE_READ], &recv_num, sizeof(int)) <= 0) {
            printf("Error reading received bytes\n");
            exit(ERROR);
        }

        // Exit if the current number is the EXIT_SIGNAL.
        if (recv_num == EXIT_SIGNAL) break;
        if (recv_num % my_num == 0) continue;

        // If this process already has a child, send the number to it.
        if (next_fd != NULL) {
            send_num(recv_num, next_fd);
            continue;
        }

        // Create a child for the process if one doesn't already exist.
        next_fd = new_pipe();
        new_pid = fork();
        if (new_pid < 0) {
            printf("Error forking process\n");
            exit(ERROR);
        } else if (new_pid > 0) {
            // Close the reading part of the child's fd and send the number to it.
            close(next_fd[PIPE_READ]);
            send_num(recv_num, next_fd);
        }
        else handle_child(next_fd);
    }

    // Shutdown the child if one exists.
    if (next_fd != NULL) {
        send_num(EXIT_SIGNAL, next_fd);
        wait(&new_pid);
        
        // Release the fds this process uses.
        close(next_fd[PIPE_WRITE]);
        free(next_fd);
    }

    // CLose the reading hand of the parent's pipe.
    close(parent_fd[PIPE_READ]);
    free(parent_fd);
    exit(SUCCESS);
}

int main(int argc, char *argv[])
{
    int* first_fd = new_pipe();
    int pid = fork();

    // Check for fork error.
    if (pid < 0) {
        printf("Error forking process\n");
        exit(ERROR);
    } else if (pid > 0) handle_parent(first_fd, pid);
    else handle_child(first_fd);
}
