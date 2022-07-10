#! /usr/bin/env dash

# ==============================================================================
# test01.sh
# Test the tigger-show command.
#
# Written by: Kristine Jin <z5362038@ad.unsw.edu.au>
# Date: 1/07/2022
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

# Check that invalid use of tigger-show give an error

# Create a simple file.

echo "line 1" > a

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check file in index

cat > "$expected_output" <<EOF
line 1
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

tigger-commit -m 'first commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check file in commit 0

cat > "$expected_output" <<EOF
line 1
EOF

tigger-show 0:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add a new file

echo "hello" > b

# make changes to previous fil 

echo "line 2" >> a

# add files to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check 'a' in staging area

cat > "$expected_output" <<EOF
line 1
line 2
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check 'b' in staging area

cat > "$expected_output" <<EOF
hello
EOF

tigger-show :b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# save changes to repository

cat > "$expected_output" <<EOF
Committed as commit 1
EOF

tigger-commit -m 'second commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check 'a' and 'b' in commit 1

cat > "$expected_output" <<EOF
line 1
line 2
EOF

tigger-show 1:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check 'b' in staging area

cat > "$expected_output" <<EOF
hello
EOF

tigger-show 1:b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# END OF TEST

echo "Test01 (tigger-show): Passed!"