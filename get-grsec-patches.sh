#!/bin/bash 

C='\e[1;33m'
NC='\e[0m'
declare -a arr=("stable" "vserver" "test")

## now loop through the above array
for i in "${arr[@]}"
do
    # getting links  
    echo -e "${C}Downloading $i grsecurity patch${NC}"	
    mkdir -p $i
    tmp=$(lynx --dump http://grsecurity.net/download.php | grep http://grsecurity.net/$i/grsecurity | grep -v iptables  |  awk '{ print $2 }')
    set -x
    cd $i 
    wget -q  $tmp 
    cd .. 
    set +x

done 

stable_changelog='http://grsecurity.net/changelog-stable2.txt' 
vserver_changelog='http://grsecurity.net/changelog-stable2vserver.txt' 
test_changelog='http://grsecurity.net/changelog-test.txt'
echo -e "${C}Downloading changelogs${NC}"	
mkdir -p changelogs 
set -x
cd changelogs 
wget -q $stable_changelog $vserver_changelog $test_changelog 
cd ..
set +x
