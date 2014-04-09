#!/bin/bash
C='\e[1;33m'
NC='\e[0m'
rss_stable='stable2_rss.php'  
rss_vserver='stable2vserver_rss.php'  
rss_testing='testing_rss.php'

declare -a ver=("stable" "vserver" "test")
declare -a rss=("stable2_rss.php"  "stable2vserver_rss.php" "testing_rss.php")
declare -a changelogs=("http://grsecurity.net/changelog-stable2.txt" "http://grsecurity.net/changelog-stable2vserver.txt" "http://grsecurity.net/changelog-test.txt")


#use: download $file
download() { 
    echo -e "${C}Downloading $1 grsecurity patch${NC}"
    tmp=$(lynx --dump http://grsecurity.net/download.php | grep http://grsecurity.net/$1/grsecurity | grep -v iptables  |  awk '{ print $2 }')
    set -x
    wget -q  $tmp
    set +x
}

#use: check $ver $rss 
check() { 
    ver=$1 
    rss=$2 
    new=$(rsstail -u http://grsecurity.net/$rss -1 | awk  '{print $2}') 
    echo $new
    cd $ver
    
    if [ ! -f $new ]; then
        echo "Downloading new version $new" 
	rm changelogs/*
	download $ver
    else
        echo "You have lastest version Grsecurity"  
   
    fi 
    cd ..
} 

download_changelogs() { 
    ch=$1 
    echo -e "${C}Downloading $ch changelogs${NC}"
    set -x
    cd changelogs 
    wget -q $ch 
    cd ..  
    set +x

}

for (( i=0; i<=2; i++ ))
do
   echo "Ckecking ${ver[$i]}" 
   check ${ver[$i]} ${rss[$i]} 
   download_changelogs ${changelogs[$i]}
done
