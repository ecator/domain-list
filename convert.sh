#!/bin/bash

# 转换Charles导出的csv文件到domains下的csv文件，自动去除重复

# 输出用法信息并结束
function echo_usage(){
	
	echo "usage: $0 charles_csv target_csv"
	exit
}

# 查找目标csv中是否已经存在指定的记录
# $1:需要查找的记录
function find_in_target(){
	lines=`cat $target_csv`
	for line in $lines; do
		if [[ $line == $1 ]]; then
			echo $1
			break
		fi
	done
}

#自动补空格
# $1:需要补空格的字符串
# $2:补完空格后的长度
# $3:是否前补空格
function fill_space(){
	input_len=${#1}
	out=$1
	if [[ $input_len -lt $2 ]]; then
		for (( i = $input_len ; i < $2; i++ )); do
			[ -z $3 ] && out="${out} " || out=" ${out}"
		done
	fi
	echo "$out"
}


if [[ -z $1 ]]; then
	echo "charles_csv error"
	echo_usage
elif [[ ! -f $1 ]]; then
	echo "$1 not found"
	echo_usage
else
	charles_csv=$1
fi


if [[ -z $2 ]]; then
	echo "target_csv error"
	echo_usage
elif [[ ! -f $2 ]]; then
	echo "$2 not found"
	echo_usage
else
	target_csv=$2
fi

echo "processing..."
cnt=0
awk -F, '{print $1}' "$charles_csv" | awk -F/ '{print $3}' | while read i
do
	echo $i | grep -E '\w+\.\w+' > /dev/null 2>&1 || continue
	if [ -n $i ] &&  [ -z `find_in_target $i` ] ;
	then
		cnt=`expr $cnt + 1`
		echo "$(fill_space $cnt 3 r): add $(fill_space $i 40) to ${target_csv}"
		echo $i>>$target_csv
	fi
done
echo "---------------end---------------"

