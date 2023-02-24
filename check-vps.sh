
#!/bin/bash
## Author : Hoang Nam
## Last Updated : 27/01/2023
## Company : AZDIG
yum install calc -y
pwdd=`pwd`
cat << "EOF"
 _   _                                          _   _
| \ | | __ _ _   _ _   _  ___ _ __             | \ | | __ _ _ __ ___
|  \| |/ _` | | | | | | |/ _ \ '_ \ _____ _____|  \| |/ _` | '_ ` _ \
| |\  | (_| | |_| | |_| |  __/ | | |_____|_____| |\  | (_| | | | | | |
|_| \_|\__, |\__,_|\__, |\___|_| |_|           |_| \_|\__,_|_| |_| |_|
       |___/       |___/
EOF

cname=$(cat /proc/cpuinfo|grep name|head -1|awk '{ $1=$2=$3=""; print }')
cores=$(cat /proc/cpuinfo|grep MHz|wc -l)
freq=$(cat /proc/cpuinfo|grep MHz|head -1|awk '{ print $4 }')
tram=$(free -m | awk 'NR==2'|awk '{ print $2 }')
#swap=$(free -m | awk 'NR==4'| awk '{ print $2 }')
swap=$(free -m | grep  Swap | awk 'NR==1' | awk '{ print $2 }')
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
cache=$((wget -O /dev/null http://cachefly.cachefly.net/100mb.test) 2>&1 | tail -2 | head -1 | awk '{print $3 $4 }')
io=$( (dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync &&rm -f test_$$) 2>&1 | tail -1| awk '{ print $(NF-1) $NF }')
IPS=$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
############################################################################
DISK_SIZE_TOTAL=$(df -kh . | tail -n1 | awk '{print $2}')
DISK_SIZE_FREE=$(df -kh . | tail -n1 | awk '{print $4}')
DISK_PERCENT_USED=$(df -kh . | tail -n1 | awk '{print $5}')
############################################################################
INODE_SIZE_TOTAL=$(df -ih . | tail -n1 | awk '{print $2}')
INODE_SIZE_FREE=$(df -ih . | tail -n1 | awk '{print $4}')
INODE_PERCENT_USED=$(df -ih . | tail -n1 | awk '{print $5}')

echo "############################################################################"
echo "CPU model : $cname"
echo "Number of cores : $cores"
echo "IP VPS : $IPS"
echo "CPU frequency : $freq MHz"
echo "Total amount of ram : $tram MB"
echo "Total amount of swap : $swap MB"
echo "System uptime : $up"
echo "Download speed : $cache "
echo "I/O speed : $io"
echo "Thông tin DISK "
echo "I/O speed : $io"

echo "################-- Thông Tin Disk > 100% is full --#########################"
echo "Total size Disk : $DISK_SIZE_TOTAL"
echo "Total size Free : $DISK_SIZE_FREE"
echo "Total size Used : $DISK_PERCENT_USED"
echo "################-- Thông Tin Inode > 100% is full --#########################"

#echo "Total size INODES : $INODE_SIZE_TOTAL"
#echo "Total size INODES : $INODE_SIZE_FREE"
echo "Total size Used INODES : $INODE_PERCENT_USED"


echo "################-- Thông Tin Ram-PHP-FPM --#########################"

yum install calc -y
svip=$(wget http://ipecho.net/plain -O - -q ; echo)
cpuname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cpucores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
cpufreq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
svram=$( free -m | awk 'NR==2 {print $2}' )
svhdd=$( df -h | awk 'NR==2 {print $2}' )
svswap=$( free -m | awk 'NR==3 {print $2}' )
echo "=========================================================================="
echo "Thong Tin Server:  "
echo "--------------------------------------------------------------------------"
echo "Server Type: $(virt-what | awk 'NR==1 {print $NF}')"
echo "CPU Type: $cpuname"
echo "CPU Core: $cpucores"
echo "CPU Speed: $cpufreq MHz"
echo "Memory: $svram MB"
echo "Disk: $svhdd"
echo "IP: $svip"

	ramformariadb=$(calc $svram/10*6)
	ramforphpnginx=$(calc $svram-$ramformariadb)
	max_children=$(calc $ramforphpnginx/30)
	memory_limit=$(calc $ramforphpnginx/5*3)M
	mem_apc=$(calc $ramforphpnginx/5)M
	buff_size=$(calc $ramformariadb/10*8)M
	log_size=$(calc $ramformariadb/10*2)M


echo "=========================================================================="
echo "Thong Tin Server:  "
echo "--------------------------------------------------------------------------"
echo "Server Type: $(virt-what | awk 'NR==1 {print $NF}')"
echo "ramformariadb Type: $ramformariadb"
echo "ramforphpnginx: $ramforphpnginx"
echo "max_children: $max_children"
echo "memory_limit: $memory_limit"
echo "mem_apc: $mem_apc"
echo "buff_size: $buff_size"
echo "log_size : $log_size"

echo "################-- Thông Tin Ram-PHP-FPM --#########################"







rm -f $pwdd/check-vps.sh

#echo "${DISK_SIZE_FREE}" available out of "${DISK_SIZE_TOTAL}" total ("${DISK_PERCENT_USED}" used).

