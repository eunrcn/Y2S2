#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static int count = 0;
static int nproc = 0;

void signal_handler(int signum) {
  // This handler does nothing; it's just used to interrupt the wait call
}

void init_barrier(int num_proc) {
  nproc = num_proc;
  count = 0;
  signal(SIGUSR1, signal_handler); // Set up signal handler
}

void reach_barrier() {
  count++;
  if (count == nproc) {
    // If this is the last process, send signal to release the barrier
    for (int i = 0; i < nproc - 1; i++)
      kill(getpid(), SIGUSR1);
  } else {
    // If not the last process, wait until released by a signal
    pause();
    // Send signal to free the next process
    kill(getpid(), SIGUSR1);
  }
}

void destroy_barrier(int my_pid) {
  if (my_pid == 0) {
    // Parent process: Nothing to clean up
  }
}
