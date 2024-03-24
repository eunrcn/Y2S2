#include <semaphore.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <unistd.h>

static int *count = NULL; // Use int pointer for shared memory
static int nproc = 0;
static int shmid = -1; // Initialize to invalid shared memory IDs
static int shmid_barrier = -1;
static int shmid_mutex = -1;
static sem_t *barrier = NULL;
static sem_t *mutex = NULL;

void signal_handler(int signum) {
  // This handler does nothing; it's just used to interrupt the wait call
}

void init_barrier(int numproc) {
  nproc = numproc;

  // Error handling for shmget
  if ((shmid = shmget(IPC_PRIVATE, sizeof(int), IPC_CREAT | 0600)) == -1) {
    perror("shmget for count");
    exit(EXIT_FAILURE);
  }
  if ((shmid_barrier = shmget(IPC_PRIVATE, sizeof(sem_t), IPC_CREAT | 0600)) ==
      -1) {
    perror("shmget for barrier");
    exit(EXIT_FAILURE);
  }
  if ((shmid_mutex = shmget(IPC_PRIVATE, sizeof(sem_t), IPC_CREAT | 0600)) ==
      -1) {
    perror("shmget for mutex");
    exit(EXIT_FAILURE);
  }

  // Error handling for shmat
  if ((count = (int *)shmat(shmid, NULL, 0)) == (int *)(-1)) {
    perror("shmat for count");
    exit(EXIT_FAILURE);
  }
  if ((barrier = (sem_t *)shmat(shmid_barrier, NULL, 0)) == (sem_t *)(-1)) {
    perror("shmat for barrier");
    exit(EXIT_FAILURE);
  }
  if ((mutex = (sem_t *)shmat(shmid_mutex, NULL, 0)) == (sem_t *)(-1)) {
    perror("shmat for mutex");
    exit(EXIT_FAILURE);
  }

  *count = 0;
  // Error handling for sem_init
  if (sem_init(barrier, 1, 0) == -1) {
    perror("sem_init for barrier");
    exit(EXIT_FAILURE);
  }
  if (sem_init(mutex, 1, 1) == -1) {
    perror("sem_init for mutex");
    exit(EXIT_FAILURE);
  }
}

void reach_barrier() {
  sem_wait(mutex);
  (*count)++;
  sem_post(mutex);
  if (*count == nproc) {
    sem_post(barrier);
  } else {
    sem_wait(barrier);
    sem_post(barrier);
  }
}

void destroy_barrier(int my_pid) {
  // Detach and remove shared memory segments
  if (shmdt(count) == -1) {
    perror("shmdt for count");
    exit(EXIT_FAILURE);
  }
  if (shmdt(barrier) == -1) {
    perror("shmdt for barrier");
    exit(EXIT_FAILURE);
  }
  if (shmdt(mutex) == -1) {
    perror("shmdt for mutex");
    exit(EXIT_FAILURE);
  }
  if (shmctl(shmid, IPC_RMID, NULL) == -1) {
    perror("shmctl for count");
    exit(EXIT_FAILURE);
  }
  if (shmctl(shmid_barrier, IPC_RMID, NULL) == -1) {
    perror("shmctl for barrier");
    exit(EXIT_FAILURE);
  }
  if (shmctl(shmid_mutex, IPC_RMID, NULL) == -1) {
    perror("shmctl for mutex");
    exit(EXIT_FAILURE);
  }

  // Destroy semaphores
  if (sem_destroy(barrier) == -1) {
    perror("sem_destroy for barrier");
    exit(EXIT_FAILURE);
  }
  if (sem_destroy(mutex) == -1) {
    perror("sem_destroy for mutex");
    exit(EXIT_FAILURE);
  }
}
