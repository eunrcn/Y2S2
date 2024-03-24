#include "barrier.h"
#include "config.h"
#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define NUM_PROCESSES 8

// Function prototypes
long int calculate_partial_sum(int start, int end, int *vect);

int main() {
  int vect[VECT_SIZE];
  int pid;
  int shmid1;
  long int *all_sum;
  clock_t start, end;
  double time_taken;

  float per_process_raw = (float)VECT_SIZE / NUM_PROCESSES;
  int per_process = (int)per_process_raw;

  if (per_process_raw != (float)per_process) {
    printf("Vector size of %d is not divisible by %d processes.\n", VECT_SIZE,
           NUM_PROCESSES);
    exit(-1);
  }

  int i;

  srand(24601);
  for (i = 0; i < VECT_SIZE; i++)
    vect[i] = rand();

  shmid1 =
      shmget(IPC_PRIVATE, NUM_PROCESSES * sizeof(long int), IPC_CREAT | 0600);
  all_sum = (long int *)shmat(shmid1, NULL, 0);

  for (i = 0; i < NUM_PROCESSES; i++) {
    pid = fork();

    if (pid == 0)
      break;
  }

  int j;
  long int sum = 0;

  if (pid == 0) {
    // Child process
    int start_index = i * per_process;
    int end_index = start_index + per_process;

    long int partial_sum = calculate_partial_sum(start_index, end_index, vect);

    all_sum[i] = partial_sum;

    exit(0); // Child process exits
  } else {
    // Parent process
    start = clock();

    // Wait for all child processes to finish
    for (j = 0; j < NUM_PROCESSES; j++)
      wait(NULL);

    // Aggregate partial sums from all child processes
    for (j = 0; j < NUM_PROCESSES; j++)
      sum += all_sum[j];

    end = clock();

    time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;

    printf("\nNumber of items: %d\n", VECT_SIZE);
    printf("Sum element is %ld\n", sum);
    printf("Time taken is %3.10f\n\n", time_taken);

    // Clean up shared memory
    shmdt(all_sum);
    shmctl(shmid1, IPC_RMID, 0);
  }

  return 0;
}

long int calculate_partial_sum(int start, int end, int *vect) {
  long int partial_sum = 0;
  int i;

  for (i = start; i < end; i++)
    partial_sum += vect[i];

  return partial_sum;
}
