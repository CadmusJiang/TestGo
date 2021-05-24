pd1="172.16.5.170"
pd2="172.16.5.131"
pd3="172.16.4.199"
tikv1="172.16.4.216"
tikv2="172.16.4.158"
tikv3="172.16.4.212"
tidb1="172.16.5.165"
tidb2="172.16.4.179"
tidb3="172.16.4.181"
home="/tmp/src/github.com/pingcap"
ACCESSKEY=""
SECRETKEY=""
size=10000000
#aws s3 name
tempMysql="qa-dbaas-cicd-mysql"
tempMysqlRegion="us-east-1"
tempBR="qa-dbaas-cicd-br"
tempBRRegion="us-east-1"

cat <<EOF > /root/config
mysql-host=$tidb1
mysql-port=4000
mysql-user=root
mysql-db=sbtest
time=600
threads=8
report-interval=10
db-driver=mysql
EOF

yum install mysql -y
yum install sysbench -y
mysql -h$tidb1 -P4000 -uroot  -e "set global tidb_hashagg_final_concurrency=1;"
mysql -h$tidb1 -P4000 -uroot  -e "set global tidb_hashagg_partial_concurrency=1;"
mysql -h$tidb1 -P4000 -uroot  -e "set global tidb_disable_txn_auto_retry=0;"
mysql -h$tidb1 -P4000 -uroot  -e "drop database sbtest;"
mysql -h$tidb1 -P4000 -uroot  -e "create database sbtest;"

nohup sysbench oltp_common \
    --threads=8 \
    --rand-type=uniform \
    --db-driver=mysql \
    --mysql-db=sbtest \
    --mysql-host=$tidb1\
    --mysql-port=4000 \
    --mysql-user=root \
    prepare --tables=16 --table-size=$size >nohup.out 2>&1 &

$home/br/bin/br backup full \
    --pd "$pd2:2379" \
    --storage "s3://$tempBR/$size?region=$tempBRRegion&access-key=$ACCESSKEY&secret-access-key=$SECRETKEY" \
    --ratelimit 120 \
    --log-file backupfull.log

