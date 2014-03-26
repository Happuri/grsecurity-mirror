#!/bin/bash

rss_stable='stable2_rss.php'  
rss_vserver='stable2vserver_rss.php'  
rss_testing='testing_rss.php'

declare -a ver=("stable" "vserver" "test")
declare -a rss=("stable2_rss.php"  "stable2vserver_rss.php" "testing_rss.php")

#use: download file
download() { 
    echo -e "${C}Downloading $1 grsecurity patch${NC}"
    tmp=$(lynx --dump http://grsecurity.net/download.php | grep http://grsecurity.net/$1/grsecurity | grep -v iptables  |  awk '{ print $2 }')
    set -x
    wget -q  $tmp
    set +x
}

#use: check ver rss 
check() { 
    ver=$1 
    rss=$2
    new=$(rsstail -u http://grsecurity.net/$rss -1 | awk  '{print $2}') 
    echo $new
    cd $ver
    if [ ! -f $new ]; then
        echo "Downloading new version $new" 
        download $ver
    else
        echo "You have lastest version Grsecurity"  
   
    fi 
    cd ..
} 

echo $1 
echo $2

#check $1 $2 

#for i in ${!arr[@]}; do 
for (( i=0; i<=2; i++ ))
    #printf "%s\t%s\n" "$i" "${foo[$i]}"
do
   echo "Ckecking ${ver[$i]}" 
   check ${ver[$i]} ${rss[$i]}

done
