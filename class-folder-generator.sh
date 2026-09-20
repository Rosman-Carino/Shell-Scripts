#!/bin/bash

# Lecture Directory Flag
create_lecture_subdirs=false
num_lectures=""
if [[ "${1:-}" == "-l"]]; then
    create_lecture_subdirs=true
    num_lectures="${2:?}"
    shift 2
fi 

# User Input Arguments
num_assignments="$1"
num_exams="$2"
num_sections="$3"

create_starter_and_submission_directories () {
    local curr_directory_name="$1"
    local num_subdirectories="$2"
    local subdir_name="${curr_directory_name%s}"
    local i
    echo "Creating Starter-Code and Submission Directories for $curr_directory_name"
    for ((i = 1; i <= num_subdirectories; i++)); do
        mkdir -p "$curr_directory_name/${subdir_name}-$i/Starter-Code" \
            "$curr_directory_name/${subdir_name}-$i/Submission"
    done
}

create_subdirectories () {
    local curr_directory_name="$1"
    local num_subdirectories="$2"
    local subdir_name="${curr_directory_name%s}"
    local j
    echo "Creating subdirectories for $curr_directory_name"
    for ((j = 1; j <= num_subdirectories; j++)); do
        mkdir -p "$curr_directory_name/${subdir_name}-$j"
    done
}

# Create Default Directories
mkdir -p Assignments Exams Lectures Lecture-Videos Sections

#Create Subdirectories for Lectures
if [[ "$create_lecture_subdirs" == true ]]; then
    echo "Lecture Subdirectory Flag is enabled"
    echo "Creating $num_lectures lecture subdirectories"
    create_subdirectories "Lectures" "$num_lectures"
else
    echo "Lecture Subdirectory is not enabled"
fi

create_starter_and_submission_directories "Assignments" "$num_assignments"
create_starter_and_submission_directories "Sections" "$num_sections"
create_subdirectories "Exams" "$num_exams"