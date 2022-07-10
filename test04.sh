#! /usr/bin/env dash

# ==============================================================================
# test04.sh
# Test the tigger-status command.
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


# ==============================================================================
# All possible cases: 
#
# a - file changed, different changes staged for commit --> "file in repo != file in index" and "file in index != working dir"
# b - file changed, changes staged for commit           --> added to index but not repo, index = working dir
# c - file changed, changes not staged for commit       --> "file in repo == file in index" but "file in index != working dir"
# d - file deleted      --> deleted in working dir but not index (i.e. with rm command)
# e - file deleted, different changes staged for commit
# f - deleted [Y]       --> deleted in both working dir and index (i.e. with tigger-rm)
# g - same as repo      --> file added to index and repo, all the same
# h - added to index    --> working dir == index, not in repo
# i - added to index, file changed          --> working dir != index, not in repo
# j - added to index, file deleted          --> in index but not in working and repo
# k - untracked         --> file is not in index
# l - untracked         --> file is in working and repo, deleted in index
# ==============================================================================


# check status of empty directory and repo

cat > "$expected_output" <<EOF
EOF

tigger-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# create a new file

touch a b c d e f g h i j k l

# check status 

cat > "$expected_output" <<EOF
a - untracked
b - untracked
c - untracked
d - untracked
e - untracked
f - untracked
g - untracked
h - untracked
i - untracked
j - untracked
k - untracked
l - untracked
EOF

tigger-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add files to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a b c d e f g l > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# add staging stage to repository

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

tigger-commit -m "first commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# make changes to file 

echo "line 1" >> a
echo "line 1" >> b

# add changes to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add a b i h j > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# make changes to file

echo "line 2" >> a
echo "line 1" >> c
echo "line 1" >> i
echo "line 1" >> e

# add files to staging area

cat > "$expected_output" <<EOF
EOF

tigger-add e > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# remove files from working directory
rm d e f j

# remove files in index

cat > "$expected_output" <<EOF
EOF

tigger-rm --cached f l > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# get status of directory and tigger repo
cat > "$expected_output" <<EOF
a - file changed, different changes staged for commit
b - file changed, changes staged for commit
c - file changed, changes not staged for commit
d - file deleted
e - file deleted, different changes staged for commit
f - deleted
g - same as repo
h - added to index
i - added to index, file changed
j - added to index, file deleted
k - untracked
l - untracked
EOF

tigger-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# END OF TEST

echo "Test04 (tigger-status): Passed!"