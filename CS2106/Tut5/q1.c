#include <stdio.h>
#include <pthread.h>

int x = 0;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void *taskA(void *arg) {
    pthread_mutex_lock(&lock);
    x++;
    pthread_mutex_unlock(&lock);
    return NULL;
}

void *taskB(void *arg) {
    pthread_mutex_lock(&lock);
    x = 2 * x;
    pthread_mutex_unlock(&lock);
    return NULL;
}

int main() {
    pthread_t threadA, threadB;

    // Create threads for Task A and Task B
    pthread_create(&threadA, NULL, taskA, NULL);
    pthread_create(&threadB, NULL, taskB, NULL);

    // Wait for threads to finish
    pthread_join(threadA, NULL);
    pthread_join(threadB, NULL);

    // Print the final value of x
    printf("Final value of x: %d\n", x);

    return 0;
}
