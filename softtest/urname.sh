#!/bin/bash
function fun(){
for i in {1..2};do
read -p "username :- " user
echo "$user"
read -p "password:- " pass
echo "$pass"
paschk=$(cat password | egrep "$user")
if [[ "$user-$pass" == $paschk ]];then
	printf "Yes\n"
else 
	printf "NO\n"
fi;
done
}
fun
cat /root/passmgr/database/xyz
