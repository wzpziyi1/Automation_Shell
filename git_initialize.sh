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

# current_branch=$(git branch | grep "*")

# echo "--------------------------------\n ${current_branch}"

branch_info=$(git pull)

# echo "--------------------------------\n ${branch_info}"

if [[ ${branch_info} =~  "Already up to date" ]]; then
    echo "--------------------------------\n remote branch no commit"
else
	echo "git pull done"
    # pod update
fi

if [[ ${is_contain} == 1 ]]; then
    git stash pop
	echo "--------------------------------\n git stash pop"
fi

# 清除上一次编译生成的文件
# iphonesimulator针对模拟器，可以改成对应的真机
# xcodebuild -workspace ${Project_Name}.xcworkspace -scheme ${Project_Name} -sdk iphonesimulator clean

# run
osascript <<EOF
	tell application "Xcode"
		open "${Project_Path}/${Project_Name}.xcworkspace"
		set workspaceDocument to workspace document "${Project_Name}.xcworkspace"
		repeat 120 times
			if loaded of workspaceDocument is true then
				exit repeat
			end if
			delay 1
		end repeat
		if loaded of workspaceDocument is false then
			error "Xcode workspace did not finish loading within timeout."
		end if
		set actionResult to run workspaceDocument
		repeat
			if completed of actionResult is true then
				exit repeat
			end if
			delay 1
		end repeat
	end tell
EOF
