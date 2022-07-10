#! /usr/bin/env dash

# ==============================================================================
# test05.sh
# Test the tigger-commit command (-a and deleted file).
#
# Written by: Kristine Jin <z5362038@ad.unsw.edu.au>
# Date: 4/07/2022
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

# commit when nothing to commit

cat > "$expected_output" <<EOF
nothing to commit
EOF

tigger-commit -m "first commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# create a new file

echo "line 1" > a 

# add file to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit file to repo

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

tigger-commit -m "first commit" > "$actual_output" 2>&1

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

# check commit record in log

cat > "$expected_output" <<EOF
0 first commit
EOF

tigger-log > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# remove file from working directory and staging area

cat > "$expected_output" <<EOF
EOF

tigger-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit file to repo

cat > "$expected_output" <<EOF
Committed as commit 1
EOF

tigger-commit -m "second commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# make sure file in repository been removed properly

cat > "$expected_output" <<EOF
tigger-show: error: 'a' not found in commit 1
EOF

tigger-show 1:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check log of last commit

cat > "$expected_output" <<EOF
1 second commit
0 first commit
EOF

tigger-log > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# create new file

echo "line 1" > A

# add new file to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# commit file to repo

cat > "$expected_output" <<EOF
Committed as commit 2
EOF

tigger-commit -m "third commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check file in repository 

cat > "$expected_output" <<EOF
line 1
EOF

tigger-show 2:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# update file

echo "line 2" >> A

# use commit with -a option to add file to staging area and repository

cat > "$expected_output" <<EOF
Committed as commit 3
EOF

tigger-commit -a -m "4th commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check index have been updated

cat > "$expected_output" <<EOF
line 1
line 2
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check index have been updated

cat > "$expected_output" <<EOF
line 1
line 2
EOF

tigger-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


# END OF TEST

echo "Test05 (tigger-commit -a rm): Passed!"