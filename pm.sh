#!/bin/bash
bold="\e[1m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
megenta="\e[35m"
cyan="\e[36m"
white="\e[37m"
end="\e[0m"
#figlet=$(figlet)
#fig=$(printf "Password Manager")
#encry=$(gpg --batch --output /root/passmgr/password1/.gpg --passphrase $pass --symmetric /root/passmgr/password)
#decry=$(gpg --batch --output /root/passmgr/password --passphrase $pass --decrypt /root/passmgr/password1/.gpg)

gpg --batch --output /root/passmgr/username --passphrase pass --decrypt /root/passmgr/username.gpg &> /dev/null
rm -f /root/passmgr/username.gpg
gpg --batch --output /root/passmgr/password --passphrase pass --decrypt /root/passmgr/password.gpg &> /dev/null
rm -f /root/passmgr/password.gpg

function login(){
                read -p "Enter Username:- " user
		chkusr=$(cat /root/passmgr/username | egrep "$user" | awk 'NR==1{print $1}' )
                if [[ $chkusr == $user ]];then
                        printf "${yellow}User is Available${end}\n"
			break
#                        exit 0;
                else
                        printf "\n${bold}${red}This user is not available${end}\n${bold}${yellow}Please Signup or Login with a different user${end}\n\n"
#                        exit 152;
                fi
}

function signup(){
                read -p "Enter Username:- " user
		chkusr=$(cat /root/passmgr/username | egrep "$user" | awk 'NR==1{print $1}')
                if [[ $chkusr == $user ]];then
                        printf "\n${bold}${red}This user is already present${end}\n${bold}${yellow}Please proceed to login or create a new user${end}\n"
#                        exit 150;
                else
                        echo "$user" | cat >> /root/passmgr/username
			read -p "Enter a Password :- " pass
			echo "$user-$pass" | cat >> /root/passmgr/password
                        printf "\n${bold}${cyan}The user has been successfully added!\nPlease proceed to Login${end}\n\n"
			unset pass
#                        exit 0;
                fi
}

#chkusr=$(cat username | egrep "$user")

while :;do
echo -e "${red}"
figlet Password
printf "${end}"
printf "${blue}"
figlet Manager
echo -e "${end}"
printf "1.Login\n2.Signup\n3.Exit\nPlease Select an option:- "
read option

#echo "$value" | cat >> testing
case $option in
	"1")
		login
		;;
	"2")	
		signup
		;;
	"3")
		exit 100;
		;;
	*)
		printf "\n${red}Invalid input${end}\n\n"
#			exit 151;
			;;
esac
done

function chpass(){
	for i in {1..3};do
		read -p "Password:- " pass
		chkpass=$(cat /root/passmgr/password | egrep "$user")
		if [[ "$user-$pass" == $chkpass ]];then
			printf "\n${bold}${green}Login Successful!${end}\n"
	break

#		elif [[ "$user-$pass" != $chkpass ]];then
		else 
			printf "${megenta}Invalid Password Try again${end}\n"
		fi;
#	break
	done

	if [[ "$user-$pass" != $chkpass ]];then
		printf "${red}3 INVALID LOGIN ATTEMPTS\nTRY AGAIN LATER${end}\n"		
		exit 171;
	else
		:
	fi
}

chpass

gpg --batch --output /root/passmgr/username.gpg --passphrase pass --symmetric /root/passmgr/username
rm -f username
gpg --batch --output /root/passmgr/password.gpg --passphrase pass --symmetric /root/passmgr/password
rm -f password

function decrypt(){
	gpg --batch --output /root/passmgr/database/$user --passphrase $pass --decrypt /root/passmgr/database/$user.gpg &> /dev/null
	rm -f /root/passmgr/database/$user.gpg
}
function encrypt(){
	gpg --batch --output /root/passmgr/database/$user.gpg --passphrase $pass --symmetric /root/passmgr/database/$user 
	rm -f /root/passmgr/database/$user
}

while :;do
echo -e "${cyan}"
figlet Password
printf "${end}"
printf "${red}"
figlet Database
echo -e "${end}"
printf "1.Add an Entry\n2.View Entries\n3.Exit\nPlease Select an option:- "
read o1

case $o1 in
	"1")
		read -p "Account Name:- " accname
		read -p "Username:- " uname
		read -p "Password:- " upass
#		gpg --batch --output $user -passphrase $pass --decrypt $user.gpg
		decrypt		
		filecheck=$(ls /root/passmgr/database/ | egrep "$user")
		if [[ $filecheck != $user ]];then
			printf "\n\nDATABASE\n" | cat >> /root/passmgr/database/$user
		else
			:
		fi
		headcheck=$(cat /root/passmgr/database/$user | egrep "Account" | awk 'NR==1{print $1}')
#		$headcheck
# 		cat /root/passmgr/database/$user | egrep "Account" | &> /dev/null 
		if [[ "$headcheck" != "Account" ]];then
			printf "Account Name\t\tUsername\t\tPassword\n" | cat >> /root/passmgr/database/$user
		else
			:
		fi		
		printf "$accname\t\t\t$uname\t\t\t$upass\n" | cat >> /root/passmgr/database/$user
		printf "\n${bold}${yellow}Entry has been added ${end}\n"
		encrypt
		;;
	"2")	
		decrypt
		printf "\n"
		cat /root/passmgr/database/$user
		encrypt
		;;
	"3")
		exit 0
		;;
	*)
		printf "Invalid Input\n"
		;;

esac
done

#gpg --batch --output username.gpg --passphrase pass --symmetric username
#rm -f username
#gpg --batch --output password.gpg --passphrase pass --symmetric password
#rm -f password
