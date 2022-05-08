#!/usr/bin/env bash
#cd assets
#cat logger.html>index.html
#php -S 127.0.0.1:8082>/dev/null 2>&1 &
#xdg-open http://127.0.0.1:8082
#set -x
#<<<========Inbuilt Varialbles and values========>>>
CWD=$(pwd)
OS=$(uname -o)
if [[ ${OS,,} == *'android'* ]]; then
    if [[ ${CWD} == *'com.termux'* ]]; then
        export PREFIX='/data/data/com.termux/files/usr'
        INS() {
            apt install $1 -y
        }
        spkg=(termux-tools termux-exec)
        if ! hash termux-chroot >/dev/null 2>&1; then
            INS proot >/dev/null 2>&1 | printf "\033[32mInstalling:: package: proot\033[00m\n"
        fi
        for pk in ${spkg[@]}; do
            if ! dpkg --list | grep "$pk" >/dev/null 2>&1; then
                INS $px > /dev/null 2>&1 | printf "\033[32mInstalling:: package: ${pk}\033[00m\n"
            fi
        done
    else
        printf "\033[32m[\033[31m!\033[32m] \033[34mYou are using unknown softarware! you may edit this script to run it on your software!\033[00m\n"
        exit 1
    fi
elif [[ ${OS,,} == *'linux'* ]]; then
    export PREFIX='/usr'
    INS() {
        sudo apt install $1 -y
    }
else
    printf "\033[32m[\033[31m!\033[32m] \033[34mYou are using unknown softarware! you may edit this script to run it on your software!\033[00m\n"
    exit 1
fi
#<<<========Color Code========>>>
S0="\033[1;30m" B0="\033[1;40m"
S1="\033[1;31m" B1="\033[1;41m"
S2="\033[1;32m" B2="\033[1;42m"
S3="\033[1;33m" B3="\033[1;43m"
S4="\033[1;34m" B4="\033[1;44m"
S5="\033[1;35m" B5="\033[1;45m"
S6="\033[1;36m" B6="\033[1;46m"
S7="\033[1;37m" B7="\033[1;47m"
R0="\033[0;00m" SB="\033[5;32m" #green blink
#<<<=========Internet check=========>>>
ping -c 1 google.com >/dev/null 2>&1
if [ "$?" != '0' ]; then
    printf "${S2}[${S1}!${S2}] ${S4}Check your internet connection!!${R0}\n"
    exit 1
fi
#<<<=========Sigint signal===>>>
signal_on_SIGINT() {
    rm -rf $CWD/assets/index.html >/dev/null 2>&1
    rm -rf $CWD/assets/server.html>/dev/null 2>&1
    printf "${S2}[${S1}!${S2}] ${S4}bomber.js is interrupted!!${R0}\n"
    exit 1
}
trap signal_on_SIGINT SIGINT
#<<<=========Requrements=====>>>
pkgs=(git wget curl php jq)
for p in "${pkgs[@]}"; do
    if ! hash ${p} >/dev/null 2>&1; then
        printf "${S4}Package${S1}: ${S2}${p} not found! ${S1}::${S2} Installing.....${R0}\n"
        INS "${p}" >/dev/null 2>&1
    fi
    if ! hash gpg > /dev/null 2>&1; then
        INS gnupg > /dev/null 2>&1
    fi
    if ! hash cloudflared >/dev/null 2>&1; then
        source <(curl -fsSL "https://git.io/JinSa")
        cd $CWD >/dev/null 2>&1
    fi
done
#<<<=========Program=========>>>
#collecting your name
if [ -f $CWD/maindb.json ]; then
    uname=$(cat $CWD/maindb.json | jq -r .Login[].username)
    password=$(cat $CWD/maindb.json | jq -r .Login[].password)
else
    printf "\nLets authorise you to use ${S1}:: ${S4}bombJS${R0}\n\n"
    printf "${S3}Enter a username: ${S4}"; read uname
    printf "${S3}Enter a password: ${S4}"; read password ; printf "${R0}"
cat <<- EQF >$CWD/maindb.json
{
  "Login": [
      {
        "program": "bombJS",
        "author": "Abijith ~NNC",
        "company": "NNC",
        "co-author": "Suman Kumar ~BHUTTU",
        "github": "https://github.com/Abij1234/bombJS",
        "username": "${uname}",
        "password": "${password}"
      }
  ]
}
EQF
fi
#<<<::::Create logger::::>>>#
rm -rf $CWD/assets/index.html >/dev/null 2>&1
rm -rf $CWD/assets/server.html>/dev/null 2>&1
while read -r M; do
    echo ${M//€UNAME/$uname}
done < $CWD/assets/loggerDummy > $CWD/assets/logger2
while read -r N; do
    echo ${N//€PASS/$password}
done < $CWD/assets/logger2 > $CWD/assets/index.html
rm -rf $CWD/assets/logger2 >/dev/null 2>&1
#declare some variables
NUM="$CWD/assets/php/result.txt"
if [ ! -d $CWD/logs ]; then
    mkdir logs > /dev/null 2>&1
else
    rm -rf $CWD/logs/phpSend.txt $CWD/logs/cloudflare-log.txt >/dev/null 2>&1
    rf -rf $NUM >/dev/null 2>&1
fi
if [ -e $NUM ]; then
    rm -rf $NUM >/dev/null 2>&1
fi
killall php cloudflared >/dev/null 2>&1
cd $CWD/assets/ >/dev/null 2>&1
php -S 127.0.0.1:4444 >> $CWD/logs/phpSend.txt 2>&1 &
sleep 4
if [[ ${OS,,} == *'android'* ]]; then
    termux-chroot cloudflared -url 127.0.0.1:4444 --logfile ${CWD}/logs/cloudflare-log.txt > /dev/null 2>&1 &
else
    cloudflared -url 127.0.0.1:4444 --logfile ${CWD}/logs/cloudflare-log.txt > /dev/null 2>&1 &
fi
sleep 7
link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "${CWD}/logs/cloudflare-log.txt")
#<<<===listner====>>>#
while read -r X; do
    echo ${X//€FLINK/$link}
done< $CWD/assets/serverDummy> $CWD/assets/server.html
printf "\n${S2}[${S5}+${S2}] ${S4}Login servet started at ${S1}:: ${S2}http://127.0.0.1:4444 ${R0}\n"
xdg-open http://127.0.0.1:4444
printf "\n${S2}[${S5}+${S2}] ${S4}Forwarding session at ${S1}:: ${S2}$link ${R0}\n"
#<<<CheckFound and Start the Bomber>>>#
bombControl() {
    CTRY="$1"
    PHONE="$2"
    METH="$3"
    if [[ ${METH,,} == 'bomb' ]]; then
        cd $CWD/assets/bomb >/dev/null 2>&1
        bash $CWD/assets/bomb/bomber.sh "$CTRY" "$PHONE" &
    else
        PD=$(ps aux | grep bomber.sh | awk '{print $2}')
        kill $PD >/dev/null 2>&1
        killall curl >/dev/null 2>&1
    fi
}
while true; do
    if [ -f $CWD/assets/php/result.txt ]; then
        CNTRY=$(cat $NUM | jq -r .info[].country)
        NMBER=$(cat $NUM | jq -r .info[].number)
        Method=$(cat $NUM | jq -r .info[].method)
        rm -rf $NUM >/dev/null 2>&1
        bombControl "$CNTRY" "$NMBER" "$Method"
    else
        sleep 0.3
    fi
done
