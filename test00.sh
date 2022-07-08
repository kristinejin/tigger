#! /usr/bin/env dash

# ==============================================================================
# test00.sh
# Test the tigger-rm command without --force or --cached.
#
# *** Note that this test is write based on the pre-condition of tigger-add, 
# tigger-commit, and tigger-show are working properly ***
#
# Written by: Kristine Jin <z5362038@ad.unsw.edu.au>
# Date: 8/07/2022
# For COMP2041 Assignment 1
# ==============================================================================

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


# Create a simple file.

echo "line 1" > test

# add a file to the repository staging area

tigger-add test > /dev/null 2>&1

# commit the file to repo

tigger-commit -m "first commit" > /dev/null 2>&1

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

#####################################################

# Check that invalid use of tigger-show give an error

# Create a simple file.

echo "line 1" > a

# add a file to the repository staging area

tigger-add a > "$actual_output" 2>&1

# check file present in index

cat > "$expected_output" <<EOF
line 1
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# try use tigger-rm

cat > "$expected_output" <<EOF
tigger-rm: error: 'a' has staged changes in the index
EOF

tigger-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 1
EOF

tigger-commit -m 'second commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check commit success

cat > "$expected_output" <<EOF
line 1
EOF

tigger-show 1:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Update the file.

echo "line 2" >> a

# update the file in the repository staging area

cat > "$expected_output" <<EOF
EOF


tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check file present in index is correct

cat > "$expected_output" <<EOF
line 1
line 2
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# try use tigger-rm

cat > "$expected_output" <<EOF
tigger-rm: error: 'a' has staged changes in the index
EOF

tigger-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

##########
 
# Update the file.

echo "line 3" >> a

# try use tigger-rm

cat > "$expected_output" <<EOF
tigger-rm: error: 'a' in index is different to both the working file and the repository
EOF

tigger-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add 'file' to staging area

cat > "$expected_output" <<EOF
EOF


tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 2
EOF

tigger-commit -m 'third commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Update the file.

echo "line 4" >> a

# use tigger-rm

cat > "$expected_output" <<EOF
tigger-rm: error: 'a' in the repository is different to the working file
EOF

tigger-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

