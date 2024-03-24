#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <semaphore.h>
#include <sys/wait.h>
#include <sys/shm.h>

#define NUM_CHILDREN 5

int main() {
    int shmid;
    sem_t *sem[NUM_CHILDREN]; // Array of semaphores
    pid_t pid;

    // Create shared memory for semaphores
    shmid = shmget(IPC_PRIVATE, sizeof(sem_t) * NUM_CHILDREN, IPC_CREAT | 0600);
    if (shmid == -1) {
        perror("shmget");
        exit(EXIT_FAILURE);
    }

    // Attach the shared memory segment
    for (int i = 0; i < NUM_CHILDREN; i++) {
        sem[i] = (sem_t *) shmat(shmid, NULL, 0);
        if (sem[i] == (void *)-1) {
            perror("shmat");
            exit(EXIT_FAILURE);
        }
    }

    // Initialize semaphores
    for (int i = 0; i < NUM_CHILDREN; i++) {
        sem_init(sem[i], 1, 0); // Initialize each semaphore with initial value 0
    }

    // Fork child processes
    for (int i = 0; i < NUM_CHILDREN; i++) {
        pid = fork();
        if (pid == 0) {
            sem_wait(sem[i]); // Wait for parent to signal before executing
            printf("Child %d! Waited 1 second for parent.\n", i + 1);
            exit(EXIT_SUCCESS);
        }
    }

    if (pid != 0) {
        // Parent process
        printf("Parent! Making my children wait for 1 second.\n");
        sleep(1);

        // Signal each child process to execute in order
        for (int i = 0; i < NUM_CHILDREN; i++) {
            sem_post(sem[i]);
            wait(NULL); // Wait for child to finish before signaling the next
        }

        // Destroy semaphores and shared memory
        for (int i = 0; i < NUM_CHILDREN; i++) {
            sem_destroy(sem[i]);
        }
        shmctl(shmid, IPC_RMID, NULL);
    }

    return 0;
}
