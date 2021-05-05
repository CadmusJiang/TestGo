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
home="/root/.gvm/pkgsets/go1.16/global/src/github.com/pingcap"
ACCESSKEY=""
SECRETKEY=""
size=10000
warehouse=100
rm -rf $home/go-ycsb
git clone https://github.com/pingcap/go-ycsb.git $home/go-ycsb
cd $home/go-ycsb
make

yum install mysql -y
#mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
#mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
#$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/minio -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
#$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/minio -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
#echo "minio"
#echo "------------------------------"

mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloada -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloada -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
echo "workloada"
echo "------------------------------"

mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadb -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadb -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
echo "workloadb"
echo "------------------------------"

mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadc -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadc -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
echo "workloadc"
echo "------------------------------"

mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadd -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadd -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
echo "workloadd"
echo "------------------------------"

mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloade -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloade -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
echo "workloade"
echo "------------------------------"

mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadf -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workloadf -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
echo "workloadf"
echo "------------------------------"

#mysql -h$tidb1 -P4000 -uroot  -e "drop database test;"
#mysql -h$tidb1 -P4000 -uroot  -e "create database test;"
#$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workload_template -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
#$home/go-ycsb/bin/go-ycsb load mysql -P $home/go-ycsb/workloads/workload_template -p mysql.host=$control -p mysql.port=$haproxyPort -p mysql.db=test
#echo "workloada_template"
#echo "------------------------------"