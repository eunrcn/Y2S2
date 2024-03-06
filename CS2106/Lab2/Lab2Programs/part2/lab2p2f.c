#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  printf("Be patient, the program will take around 7 seconds to run.\n");
  printf("At the end, you can do \"cat results.out\" to see the result.\n");

  int pipe_fd[2];
  pid_t pid;

  // Create a pipe
  if (pipe(pipe_fd) == -1) {
    perror("pipe");
    exit(EXIT_FAILURE);
  }

  // Fork the process
  pid = fork();

  if (pid == -1) {
    perror("fork");
    exit(EXIT_FAILURE);
  }

  if (pid == 0) {
    // Child process

    // Close the write end of the pipe
    close(pipe_fd[1]);

    // Redirect standard input to read from the pipe
    dup2(pipe_fd[0], STDIN_FILENO);

    // Close unused file descriptors
    close(pipe_fd[0]);

    // Redirect standard output to write to "results.out"
    int output_file = open("results.out", O_WRONLY | O_CREAT | O_TRUNC, 0666);
    dup2(output_file, STDOUT_FILENO);

    // Close unused file descriptors
    close(output_file);

    // Execute the "./talk" command
    execlp("./talk", "./talk", (char *)NULL);

    // If execlp fails
    perror("execlp");
    exit(EXIT_FAILURE);
  } else {
    // Parent process

    // Close the read end of the pipe
    close(pipe_fd[0]);

    // Fork another process
    pid_t slow_pid = fork();

    if (slow_pid == -1) {
      perror("fork");
      exit(EXIT_FAILURE);
    }

    if (slow_pid == 0) {
      // Child process of the parent

      // Redirect standard output to write to the pipe
      dup2(pipe_fd[1], STDOUT_FILENO);

      // Close unused file descriptors
      close(pipe_fd[1]);

      // Execute the "./slow 5" command
      execlp("./slow", "./slow", "5", (char *)NULL);

      // If execlp fails
      perror("execlp");
      exit(EXIT_FAILURE);
    } else {
      // Parent process

      // Close the write end of the pipe
      close(pipe_fd[1]);

      // Wait for the child processes to finish
      waitpid(slow_pid, NULL, 0);
      waitpid(pid, NULL, 0);
    }
  }

  return 0;
}
