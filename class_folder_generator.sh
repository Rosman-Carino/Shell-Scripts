#!/bin/bash
# class_folder_generator.sh
# Description: Creates a course directory structure for a class.
# Author:      Rosman R Carino
# Usage:       ./make_class_dirs.sh [-h] [-l <num_lectures>] <class_name> <num_assignments> <num_exams> <num_sections>

set -u

usage="Usage: $0 [-l <num_lectures>] <class_name> <num_assignments> <num_exams> <num_sections>"

show_help() {
    cat <<EOF
$usage

Creates a course directory structure for a class.

Arguments:
  class_name         Name of the top-level folder (e.g. CS101)
  num_assignments    Number of Assignment-N folders, each with Starter-Code and Submission
  num_exams          Number of Exam-N folders
  num_sections       Number of Section-N folders, each with Starter-Code and Submission

Options:
  -l <num_lectures>  Also create Lecture-N folders inside Lectures
  -h, --help         Show this help message and exit

Structure created:
  <class_name>/
  ├── Assignments/Assignment-N/{Starter-Code,Submission}
  ├── Exams/Exam-N
  ├── Lectures/            (Lecture-N only if -l is used)
  ├── Lecture-Videos/
  └── Sections/Section-N/{Starter-Code,Submission}

Examples:
  $0 CS101 5 2 4
  $0 -l 10 CS101 5 2 4

Options must come before the positional arguments.
EOF
}

# Help flag (must be checked first)
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
    exit 0
fi

# Lecture Directory Flag
create_lecture_subdirs=false
num_lectures=""
if [[ "${1:-}" == "-l" ]]; then
    create_lecture_subdirs=true
    num_lectures="${2:?$usage}"
    shift 2
fi 

# User Input Arguments
class_name="${1:?$usage}"
num_assignments="${2:?$usage}"
num_exams="${3:?$usage}"
num_sections="${4:?$usage}"

#Validate Arguments
nums=("$num_assignments" "$num_exams" "$num_sections")
if [[ "$create_lecture_subdirs" == true ]]; then
    nums+=("$num_lectures")
fi

for num in "${nums[@]}"; do
    if [[ ! "$num" =~ ^[0-9]+$ ]]; then
        echo "Error: Arguments must be non-negative integers (got '$num')">&2
        exit 1 
    fi
done

create_starter_and_submission_directories () {
    local curr_directory_name="$1"
    local num_subdirectories="$2"
    local subdir_name="${curr_directory_name%s}"
    local i
    echo "Creating Starter-Code and Submission Directories for $curr_directory_name"
    for ((i = 1; i <= num_subdirectories; i++)); do
        mkdir -p "$class_name/$curr_directory_name/${subdir_name}-$i/Starter-Code" \
            "$class_name/$curr_directory_name/${subdir_name}-$i/Submission"
    done
}

create_subdirectories () {
    local curr_directory_name="$1"
    local num_subdirectories="$2"
    local subdir_name="${curr_directory_name%s}"
    local j
    echo "Creating $num_subdirectories subdirectories for $curr_directory_name directory"
    for ((j = 1; j <= num_subdirectories; j++)); do
        mkdir -p "$class_name/$curr_directory_name/${subdir_name}-$j"
    done
}

# Create Default Directories
mkdir -p "$class_name"/{Assignments,Exams,Lectures,Lecture-Videos,Sections}

#Create Subdirectories for Lectures
if [[ "$create_lecture_subdirs" == true ]]; then
    echo "Lecture Subdirectory Flag is enabled"
    create_subdirectories "Lectures" "$num_lectures"
else
    echo "Lecture Subdirectory is not enabled"
fi

create_starter_and_submission_directories "Assignments" "$num_assignments"
create_starter_and_submission_directories "Sections" "$num_sections"
create_subdirectories "Exams" "$num_exams"
echo "Completion: $class_name class directory completed."