#!/bin/bash

download(){
	while read -r blocklist
	do
		if [[ "${blocklist:0:1}" != '#' ]]
		then
			OK=0
			curl -fsSL $blocklist && OK=1
			if [[ $OK -eq 0 ]]
			then
				echo $blocklist : innacessible >&2
			else
				echo $blocklist : OK >&2
			fi
		fi
	done < ./sources.list
}

LIST=$(download)


IP_LIST=$(echo "$LIST" | grep -oEf IP_filter.re | sort | uniq)

echo "$IP_LIST" | sort | uniq | grep -v '0.0.0.0' > merge.txt

cat blocklist.txt 2>/dev/null >> merge.txt
cat merge.txt | sort | uniq | tee blocklist.txt
