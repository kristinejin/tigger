#! /usr/bin/env dash

# ==============================================================================
# test00.sh
# Test the tigger-log command.
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

# check commit record in log

cat > "$expected_output" <<EOF
EOF

tigger-log > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

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

# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

tigger-commit -m 'first commit' > "$actual_output" 2>&1

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

# make changes to previous file

echo "line 2" >> a

# add files to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a > "$actual_output" 2>&1

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

# make changes to previous file

echo "line 1" >> b
echo "line 1" >> c
echo "line 1" >> d

# add files to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# save changes to repository

cat > "$expected_output" <<EOF
Committed as commit 2
EOF

tigger-commit -m 'third commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add files to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add c > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# save changes to repository

cat > "$expected_output" <<EOF
Committed as commit 3
EOF

tigger-commit -m 'forth commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add files to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add d > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# save changes to repository

cat > "$expected_output" <<EOF
Committed as commit 4
EOF

tigger-commit -m 'fifth commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# check tigger-log print in descending order

cat > "$expected_output" <<EOF
4 fifth commit
3 forth commit
2 third commit
1 second commit
0 first commit
EOF

tigger-log > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi


# END OF TEST

echo "Test00 (tigger-log): Passed!"
