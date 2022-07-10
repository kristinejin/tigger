#! /usr/bin/env dash

# ==============================================================================
# test02.sh
# Test proper use of tigger-rm command without --force or --cached.
#
# Written by: Kristine Jin <z5362038@ad.unsw.edu.au>
# Date: 2/07/2022
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


# Create a simple file.

echo "line 1" > test

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF

tigger-add test > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit the file to repo
cat > "$expected_output" <<EOF
Committed as commit 0
EOF

tigger-commit -m "first commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# remove file in current directory and staging area

cat > "$expected_output" <<EOF
EOF

tigger-rm test > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check if file in staging area have been removed successfully

cat > "$expected_output" <<EOF
tigger-show: error: 'test' not found in index
EOF

tigger-show :test > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check if file in working directory have been removed successfully
cat > "$expected_output" <<EOF
find: test: No such file or directory
EOF

find test > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# NOTE: when f deleted in working directory but not index ? may solved --> test case

# restore test file

echo "restore" > test

# add test file to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add test > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add test file to repository

cat > "$expected_output" <<EOF
Committed as commit 1
EOF

tigger-commit -m "second commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test, 145"
    exit 1
fi

# remove file in working directory

rm test

# remove file using tigger-rm

cat > "$expected_output" <<EOF
EOF

tigger-rm test > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test, 161"
    exit 1
fi

# check file been removed in index

cat > "$expected_output" <<EOF
tigger-show: error: 'test' not found in index
EOF

tigger-show :test > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


# END OF TEST

echo "Test02 (tigger-rm simple): Passed!"