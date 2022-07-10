#! /usr/bin/env dash

# ==============================================================================
# test09.sh
#
# Test tigger-branch list, create delete branch
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

# Create tigger repository

cat > "$expected_output" <<EOF
Initialized empty tigger repository in .tigger
EOF

tigger-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test, tigger-init"
    exit 1
fi


##################################################################
###                     Starter Code End                       ###
##################################################################

# create a new branch

cat > "$expected_output" <<EOF
EOF

tigger-branch "branch1" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# list branches 

cat > "$expected_output" <<EOF
branch1
master
EOF

tigger-branch > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# remove branch

cat > "$expected_output" <<EOF
Deleted branch 'branch1'
EOF

tigger-branch -d branch1 > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# list branches 

cat > "$expected_output" <<EOF
master
EOF

tigger-branch > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi



# END OF TEST

echo "Test09 (tigger-branch): Passed!"