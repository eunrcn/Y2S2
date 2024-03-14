#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define NUM_CHILDREN 5
#define SHM_KEY 1234

int main() {
  int shmid;
  int *counter;

  // Create shared memory segment
  shmid = shmget(SHM_KEY, sizeof(int), IPC_CREAT | 0666);
  if (shmid == -1) {
    perror("shmget");
    exit(EXIT_FAILURE);
  }

  // Attach shared memory segment
  counter = (int *)shmat(shmid, NULL, 0);
  if (counter == (int *)(-1)) {
    perror("shmat");
    exit(EXIT_FAILURE);
  }

  *counter = 0;

  pid_t pid;

  for (int i = 0; i < NUM_CHILDREN; i++) {
    pid = fork();
    if (pid == 0)
      break;
  }

  if (pid < 0) {
    perror("fork");
    exit(EXIT_FAILURE);
  } else if (pid == 0) {
    // Child process
    printf("Child %d starts\n", i + 1);

    // Simulate some work
    for (int j = 0; j < 5; j++) {
      (*counter)++;
      printf("Child %d increment counter %d\n", i + 1, *counter);
      fflush(stdout);
      usleep(250000);
    }

    printf("Child %d finishes with counter %d\n", i + 1, *counter);

    // Detach shared memory segment
    if (shmdt(counter) == -1) {
      perror("shmdt");
      exit(EXIT_FAILURE);
    }

    exit(EXIT_SUCCESS);
  }

  // Parent process
  for (int i = 0; i < NUM_CHILDREN; i++) {
    wait(NULL);
  }

  // Print the final value of the counter
  printf("Final counter value: %d\n", *counter);

  // Remove shared memory segment
  if (shmctl(shmid, IPC_RMID, NULL) == -1) {
    perror("shmctl");
    exit(EXIT_FAILURE);
  }

  return 0;
}
