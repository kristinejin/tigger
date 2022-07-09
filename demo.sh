#! /bin/dash

# if [ -f ".tigger/HEAD" ]
# then
#     echo "This file exists on your filesystem."
# fi

# hello

# index=.tigger/branches/master/index
# for f in $index/*
# do 
#     echo $f
#     echo 1
# done

# currBranch="$(cat .tigger/HEAD)"
# currBranchFolder=.tigger/branches/$currBranch
# index=.tigger/branches/"$currBranch"/index

# find "$index"
# if [ -d "$index" ]
# then
#     echo "n"
#     exit 0
# fi
# echo "yes"

# true=1
# if "$true"
# then
#     echo true
# fi

i=1
j=2
a="$i""$j"
echo $a