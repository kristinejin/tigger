#! /usr/bin/env dash

# ==============================================================================
# test06.sh
# Test invalid use of tigger-add and tigger-commit
#
# Written by: Kristine Jin <z5362038@ad.unsw.edu.au>
# Date: 8/07/2022
# For COMP2041 Assignment 1
# ==============================================================================

##################################################################
###  The below stater code is from Comp2041 Tutorial Question  ###
##################################################################

# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" && cd .. && rm -rf "$test_dir"' INT HUP QUIT TERM EXIT


##################################################################
###                     Starter Code End                       ###
##################################################################

# make a new file

echo 1 > a

# Use tigger commands without a repository

cat > "$expected_output" <<EOF
tigger-add: error: tigger repository directory .tigger not found
EOF

tigger-add a > "$actual_output" 2>&1

# if [ "$?" -eq 0 ]; then
#     echo "Failed test"
#     exit 1
# fi

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
tigger-commit: error: tigger repository directory .tigger not found
EOF

tigger-commit -m "invalid" > "$actual_output" 2>&1

if [ "$?" -eq 0 ]; then
    echo "Failed test"
    exit 1
fi

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Create tigger repository

cat > "$expected_output" <<EOF
Initialized empty tigger repository in .tigger
EOF

tigger-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test, tigger-init"
    exit 1
fi

# use tigger-add with no argument

cat > "$expected_output" <<EOF
usage: tigger-add <filenames>
EOF

tigger-add > "$actual_output" 2>&1

if [ "$?" -eq 0 ]; then
    echo "Failed test"
    exit 1
fi

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add non-existant file 

cat > "$expected_output" <<EOF
tigger-add: error: can not open 'nonexistant'
EOF

tigger-add nonexistant > "$actual_output" 2>&1

if [ "$?" -eq 0 ]; then
    echo "Failed test"
    exit 1
fi

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add a valid file to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Invalid commit option

cat > "$expected_output" <<EOF
usage: tigger-commit [-a] -m commit-message
EOF

tigger-commit -l -m "invalid" > "$actual_output" 2>&1

if [ "$?" -eq 0 ]; then
    echo "Failed test"
    exit 1
fi

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
usage: tigger-commit [-a] -m commit-message
EOF

tigger-commit -m > "$actual_output" 2>&1

if [ "$?" -eq 0 ]; then
    echo "Failed test"
    exit 1
fi

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
usage: tigger-commit [-a] -m commit-message
EOF

tigger-commit "helo" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output" || [ "$?" -eq 0 ]; then
    echo "Failed test"
    exit 1
fi

# END OF TEST

echo "Test06 (tigger-commit add erros): Passed!"