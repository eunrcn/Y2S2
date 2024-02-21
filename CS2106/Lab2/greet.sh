#!/bin/bash

# Get user's name
user=$(whoami)

# Get current day, date, month, year, and time
dayOfWeek=$(date +%A)
day=$(date +%d)
month=$(date +%B)
year=$(date +%Y)
time=$(date +%H:%M:%S)

# Print the greeting
echo "Hello $user, today is $dayOfWeek, $day $month $year and the time is $time"
