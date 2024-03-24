#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define NUM_CHILDREN 5

int main() {
  int shmid;
  key_t key = IPC_PRIVATE; // Private key for shared memory
  int *counter;            // Pointer to shared memory

  // Create shared memory segment
  if ((shmid = shmget(key, sizeof(int), IPC_CREAT | 0666)) < 0) {
    perror("shmget");
    exit(EXIT_FAILURE);
  }

  // Attach shared memory
  if ((counter = shmat(shmid, NULL, 0)) == (int *)-1) {
    perror("shmat");
    exit(EXIT_FAILURE);
  }

  *counter = 0; // Initialize counter

  pid_t pid;

  for (int i = 0; i < NUM_CHILDREN; i++) {
    pid = fork();
    if (pid == 0) {
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
      exit(EXIT_SUCCESS);
    } else if (pid < 0) {
      perror("fork");
      exit(EXIT_FAILURE);
    }
  }

  // Parent process
  for (int i = 0; i < NUM_CHILDREN; i++) {
    wait(NULL);
  }

  // Print the final value of the counter
  printf("Final counter value: %d\n", *counter);

  // Detach shared memory
  if (shmdt(counter) == -1) {
    perror("shmdt");
    exit(EXIT_FAILURE);
  }

  // Remove shared memory segment
  if (shmctl(shmid, IPC_RMID, NULL) == -1) {
    perror("shmctl");
    exit(EXIT_FAILURE);
  }

  return 0;
}
