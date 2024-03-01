#!/bin/bash

# Clear the result.out file at the beginning of the script
echo -n > "results.out"
echo -n > "subs/A0285757B/results.out"
echo -n > "subs/A0183741Y/results.out"
echo -n > "subs/A0281754H/results.out"


# Check if exactly one argument is supplied
if [ "$#" -ne 1 ]; then
    echo "Usage: ./grade.sh <filename>"
    exit 1
fi

# Compile the C source files in ref/
if gcc ref/*.c -o $1 &> /dev/null; then
    echo "Compilation successful."
else
    echo "Compilation failed."
    exit 1
fi

# Delete all output reference files (*.out) in ref/
rm ref/*.out

# Generate new output reference files
for infile in ref/*.in; do
    outfile=${infile%.in}.out
    ./$1 < $infile > $outfile
done

# Initialize variables for tracking scores
total_files=0
total_score=0

# Iterate over every student directory in subs/
for student_dir in subs/*/; do
    student_id=$(basename $student_dir)
    result_file="$student_dir/results.out"

    # Compile the code in the student's directory
    if gcc "$student_dir"/*.c -o "$1" 2>/dev/null; then
        echo "Compilation successful for directory $student_id."
    else
        echo "Directory $student_id has a compile error." >> "$result_file"
        echo "Directory $student_id score 0 / $(ls ref/*.in | wc -l)" >> "$result_file"
        total_files=$((total_files + 1))
        continue
    fi


    # Initialize variables for tracking student's score
    student_score=0

    # Generate output files for each ".in" file in ref/
    for infile in ref/*.in; do
        outfile=${infile%.in}.out
        student_outfile="$student_dir/$(basename $outfile)"

        ./$1 < $infile > $student_outfile

        # Compare the output files using diff and award points
        if diff -q $student_outfile $outfile > /dev/null; then
            student_score=$((student_score + 1))
        fi
    done

    total_score=$((total_score + student_score))
    total_files=$((total_files + 1))

    # Print out the points awarded to the student
    echo "Directory $student_id score $student_score / $(ls ref/*.in | wc -l)" >> $result_file
done

# Print the overall results to results.out
echo "Test date and time: $(date '+%A, %d %B %Y, %T')" > results.out
echo >> results.out

# Display a more concise message for directories with compile errors
cat subs/*/results.out | sed 's/ has a compile error./ has compile error./' >> results.out
echo >> results.out
echo "Processed $total_files files." >> results.out
