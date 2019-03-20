#!/bin/sh
# 修改这两个，项目路径和app名字
Project_Path="/Users/wzp/yylive-ios"
Project_Name="YYMobile"


cd ${Project_Path}

# 需要回滚的commit文件，也就是不需要提交的
git checkout -- YYMobile/LibraryVersionNumber.json
git checkout -- YYMobile/SdkVersionNumber.json

changes=$(git status)
no_modified="nothing to commit"
is_contain=0
if [[ ${changes} =~ ${no_modified} ]]; then
    echo "--------------------------------\n no modified file"
else
    git stash save "day_initialize"
    is_contain=1
    echo "--------------------------------\n git stash save day_initialize"
fi

current_branch=$(git branch | grep "*")

# echo "--------------------------------\n ${current_branch}"

branch_info=$(git pull origin ${current_branch}:${current_branch})

# echo "--------------------------------\n ${branch_info}"

if [[ ${branch_info} =~  "Already up to date" ]]; then
    echo "--------------------------------\n remote branch no commit"
fi

if [[ ${is_contain} == 1 ]]; then
    git stash pop
	echo "--------------------------------\n git stash pop"
fi

git commit -a
git push