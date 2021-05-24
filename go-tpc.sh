pd1="172.16.5.170"
pd2="172.16.5.131"
pd3="172.16.4.199"
tikv1="172.16.4.216"
tikv2="172.16.4.158"
tikv3="172.16.4.212"
tidb1="172.16.5.165"
tidb2="172.16.4.179"
tidb3="172.16.4.181"
control="172.16.6.177"
haproxyPort="4000"
home="/tmp/src/github.com/pingcap"
ACCESSKEY=""
SECRETKEY=""
size=10000
warehouse=300
cd $home
git clone https://github.com/pingcap/go-tpc.git
cd $home/go-tpc
make build
yum install mysql -y
mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
mysql -h$tidb1 -P4000 -uroot  -e "create database test;"

$home/go-tpc/bin/go-tpc tpcc prepare --warehouses $warehouse -D test -H $control -P $haproxyPort -T 8 -U root
$home/go-tpc/bin/go-tpc tpcc --warehouses $warehouse run -D test -H $control -P $haproxyPort -T 8 -U root & { sleep 100; kill $! & }
#$home/go-tpc/bin/go-tpc tpcc --warehouses $warehouse cleanup