#! /usr/bin/env dash

# ==============================================================================
# test03.sh
# Test the tigger-rm with options --force / --cached.
#
# Written by: Kristine Jin <z5362038@ad.unsw.edu.au>
# Date: 3/07/2022
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

echo "line 1" > a

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# remove file in staging area

cat > "$expected_output" <<EOF
EOF

tigger-rm --cached a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# make sure file in staging area been removed properly

cat > "$expected_output" <<EOF
tigger-show: error: 'a' not found in index
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add file to staging area again 

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# ignore warning and remove file from working directory and staging area

cat > "$expected_output" <<EOF
EOF

tigger-rm --force a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# make sure file in staging area been removed properly

cat > "$expected_output" <<EOF
tigger-show: error: 'a' not found in index
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# make sure file in working been removed properly

cat > "$expected_output" <<EOF
find: a: No such file or directory
EOF

find a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# create a new file

echo "line 1" > a

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

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

# edit file in working area

echo "line 2" >> a

# add file to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# edit file in working area again

echo "line 1" >> a

# unsuccess remove file in staging area without force 

cat > "$expected_output" <<EOF
tigger-rm: error: 'a' in index is different to both the working file and the repository
EOF

tigger-rm --cached a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# remove file in staging area with --force

cat > "$expected_output" <<EOF
EOF

tigger-rm --force --cached a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# END OF TEST

echo "Test03 (tigger-rm --force --cached): Passed!"