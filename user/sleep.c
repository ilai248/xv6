#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

enum ArgvIndexes {PROGRAM_NAME_INDEX, SLEEP_DURATION_INDEX};
enum ReturnCodes {SUCCESS, ERROR};

int main(int argc, char *argv[])
{
  // Ensure correct argc (args count).
  if(argc != SLEEP_DURATION_INDEX + 1 ){
    printf("Wrong Format. Correct Format is:\n\t%s %s", argv[PROGRAM_NAME_INDEX], "<Number Of Ticks To Wait>\n");
    exit(ERROR);
  }

  // Make sure the given amount of ticks is a positive integer (if it's not an integer then 0 will be returned).
  int ticksToWait = atoi(argv[SLEEP_DURATION_INDEX]);
  if (ticksToWait <= 0) {
    printf("Error: Number of ticks must be a positive integer.\n");
    exit(ERROR);
  }

  sleep(ticksToWait);
  exit(SUCCESS);
}
