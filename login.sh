#!/bin/bash

BASE_DIR=`dirname $0`
BASE_DIR=`cd $BASE_DIR; pwd`
echo "BASE_DIR : $BASE_DIR"
HOST_DIR="$BASE_DIR/hosts"

function color(){
    blue="\033[0;36m"
    red="\033[0;31m"
    green="\033[0;32m"
    close="\033[m"
    case $1 in
        blue)
            echo -e "$blue $2 $close"
        ;;
        red)AA
            echo -e "$red $2 $close"
        ;;
        green)
            echo -e "$green $2 $close"
        ;;
        *)
            echo "Input color error!!"
        ;;
    esac
}

function copyright(){
    echo "############################################################################"
    color blue " SSH login support by Sefarious "
    echo "############################################################################"
}

function underline(){
    echo "----------------------------------------------------------------------------"
}

function listHost(){
    clear
    copyright
    underline
    echo "CURRENT : "$1
    underline
    echo " SEQ | HOST                                     | DESC "
    underline
    awk 'BEGIN {FS=":"} {printf(" \033[0;31m%3d\033[m | %-40s | %20s \n",$1,$2,$6)}' $1
    underline
    echo " q : quit, p : pre level, or seq you want"
    underline
}

function listDir(){
    clear
    copyright
    underline
    echo "CURRENT : "$1
    underline
    echo " SEQ | TYPE | NAME "
    underline
    #ls $1 | awk -v num=1 'BEGIN {FS=" "} {printf(" \033[0;31m%3d\033[m | %-20s\n",num,$1); num=num+1}'
    ls -l $1 | sed '1d' | awk -v num=1 'BEGIN {FS=" "} { if($1 ~ /^d/)printf(" \033[0;31m%3d\033[m |    D | \033[0;35m%-20s\033[m\n",num,$9);else printf(" \033[0;31m%3d\033[m |    F | \033[0;32m%-20s\033[m\n",num,$9); num=num+1}'
    underline
    echo " q : quit, p : pre level, or seq you want"
    underline
}

function choseDir(){
    listDir $1
    read -p '[*] chose dir : ' number
    case $number in
        [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
            dirName=$(ls $1 | awk -v num=1 -v number=$number 'BEGIN {FS=" "} {if(num == number){print $1}; num=num+1}')
            if [ "X$dirName" == "X" ]; then
                echo "chose mismatch : $number"
                sleep 1s
                choseDir $1
            else
                echo "chose : "$dirName
                if [ -d $1/$dirName ]; then
                    echo "It is a directory"
                    choseDir $1/$dirName
                elif [ -f $1/$dirName ]; then
                    echo "It is a file"
                    choseHost  $1/$dirName
                else
                    echo "no choice match"
                    exit
                fi
            fi
        ;;
        "p"|"pre")
            if [ "$1" == "$HOST_DIR" ]; then
                choseDir $1
            else
                choseDir ${1%/*} 
            fi
        ;;
        "q"|"quit")
            exit
        ;;
        *)
            echo "Input error!!"
        ;;
    esac
}

function choseHost(){
    listHost $1
    read -p '[*] chose host : ' number
    case $number in
        [0-9]|[0-9][0-9]|[0-9][0-9][0-9])
            ipaddr=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $2}}' $1)
            port=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $3}}' $1)
            username=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $4}}' $1)
            passwd=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $5}}' $1)
            echo $passwd | grep -q ".pem$"
            RETURN=$?
            clear
            if [[ $RETURN == 0 ]];then
                ssh -i $BASE_DIR/keys/$passwd $username@$ipaddr -p $port
                echo "ssh -i $BASE_DIR/$passwd $username@$ipaddr -p $port"
            else
                if [ "X$passwd" == "X" ]; then
                    expect -f $BASE_DIR/ssh_login_pwd_ipt.exp $ipaddr $username          $port
                elif [ "X$passwd" == "Xpassword" ]; then
                    expect -f $BASE_DIR/ssh_login.exp         $ipaddr $username password $port
                else
                    expect -f $BASE_DIR/ssh_login.exp         $ipaddr $username $passwd  $port
                fi
            fi
        ;;
        "p"|"pre")
            if [ "$1" == "$HOST_DIR" ]; then
                choseDir $1
            else
                choseDir ${1%/*} 
            fi
        ;;
        "q"|"quit")
            exit
        ;;

        *)
            echo "Input error!!"
        ;;
    esac
}

while [ True ]; do
    choseDir $HOST_DIR
done
