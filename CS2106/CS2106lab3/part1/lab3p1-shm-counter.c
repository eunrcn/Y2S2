#include <fcntl.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define NUM_CHILDREN 5

int main() {
  // Variables for shared memory
  int *counter, *turn;
  int shmid_counter, shmid_turn;

  // Process ID
  pid_t pid;

  // Create and attach shared memory for counter
  shmid_counter = shmget(IPC_PRIVATE, sizeof(int), IPC_CREAT | 0600);
  counter = (int *)shmat(shmid_counter, NULL, 0);

  // Create and attach shared memory for turn
  shmid_turn = shmget(IPC_PRIVATE, sizeof(int), IPC_CREAT | 0600);
  turn = (int *)shmat(shmid_turn, NULL, 0);

  // Initialize counter and turn to 0
  *counter = 0;
  *turn = 0;

  // Fork child processes
  for (int i = 0; i < NUM_CHILDREN; i++) {
    pid = fork();
    if (pid == 0)
      break; // Child process breaks out of loop
  }

  // Handle fork errors
  if (pid < 0) {
    perror("fork");
    exit(EXIT_FAILURE);
  }
  // Child process logic
  else if (pid == 0) {
    // Wait for its turn
    while (*turn != getpid() % NUM_CHILDREN)
      ;

    // Child process
    printf("Child %d starts\n", getpid() % NUM_CHILDREN + 1);

    // Simulate some work
    for (int j = 0; j < 5; j++) {
      (*counter)++;
      printf("Child %d increments counter %d\n", getpid() % NUM_CHILDREN + 1,
             *counter);
      fflush(stdout);
      usleep(250000);
    }

    // Finish
    printf("Child %d finishes with counter %d\n", getpid() % NUM_CHILDREN + 1,
           *counter);

    // Pass the turn to the next process
    *turn = (*turn + 1) % NUM_CHILDREN;

    // Detach shared memory
    shmdt(counter);
    shmdt(turn);

    exit(EXIT_SUCCESS);
  }

  // Parent process waits for child processes to finish
  for (int i = 0; i < NUM_CHILDREN; i++) {
    wait(NULL);
  }

  // Print the final value of the counter
  printf("Final counter value: %d\n", *counter);

  // Detach shared memory
  shmdt(counter);
  shmdt(turn);

  // Destroy shared memory segments
  shmctl(shmid_counter, IPC_RMID, 0);
  shmctl(shmid_turn, IPC_RMID, 0);

  return 0;
}
