#!/bin/bash

# 检测域名是否有正确的解析

# 输出用法信息并结束
function echo_usage(){
	
	echo "usage: $0 csv [update]"
	exit
}

#自动补空格
# $1:需要补空格的字符串
# $2:补完空格后的长度
# $3:是否前补空格
function fill_space(){
	input_len=${#1}
	fill_out=$1
	if [[ $input_len -lt $2 ]]; then
		for (( i = $input_len ; i < $2; i++ )); do
			[ -z $3 ] && fill_out="${fill_out} " || fill_out=" ${fill_out}"
		done
	fi
	echo "$fill_out"
}

if [[ -z $1 ]]; then
	echo "csv file error"
	echo_usage
elif [[ ! -f $1 ]]; then
	echo "$1 not found"
	echo_usage
else
	csv=$1
fi

out=""
cnt_ok=0
cnt_ng=0
csv_content=`cat $csv`
for line in $csv_content ; do
	nslookup $line 114.114.114.114 > /dev/null
	if [ $? -eq 0 ]
	then
		((cnt_ok++))
		echo "$(fill_space $cnt_ok 3 r): $(fill_space $line 40) ok"
		[ -z $out ] && out="${line}" || out="${out}\n${line}"
	else
		((cnt_ng++))
		echo "$(fill_space $cnt_ng 3 r): $(fill_space $line 40) ng"
	fi
done
echo '--------------end--------------'
echo "check ok: ${cnt_ok}"
echo "check ng: ${cnt_ng}"
if [[ -n $2 ]]
then
	echo -e $out>$csv
	echo "${csv} update ok"
fi

