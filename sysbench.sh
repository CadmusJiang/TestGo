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
size=1000

#aws s3 name
tempBR="qa-dbaas-cicd-br"
tempBRRegion="us-east-1"

yum install mysql -y
yum install sysbench -y
mysql -h$control -P$haproxyPort -uroot  -e "set global tidb_hashagg_final_concurrency=1;"
mysql -h$control -P$haproxyPort -uroot  -e "set global tidb_hashagg_partial_concurrency=1;"
mysql -h$control -P$haproxyPort -uroot  -e "set global tidb_disable_txn_auto_retry=0;"

mysql -h$control -P$haproxyPort -uroot  -e "drop database sbtest;"
mysql -h$control -P$haproxyPort -uroot  -e "create database sbtest;"
$home/br/bin/br restore full \
    --pd "$pd1:2379" \
    --storage "s3://$tempBR/$size?region=$tempBRRegion&access-key=$ACCESSKEY&secret-access-key=$SECRETKEY" \
    --ratelimit 128 \
    --log-file restorefull.log

sysbench oltp_point_select \
    --threads=8 \
    --time=300 \
    --report-interval=1 \
    --rand-type=uniform \
    --db-driver=mysql \
    --mysql-db=sbtest \
    --mysql-host=$control\
    --mysql-port=$haproxyPort \
    --mysql-user=root \
    run --tables=16 --table-size=$size
echo "point_select"

mysql -h$control -P$haproxyPort -uroot  -e "drop database sbtest;"
mysql -h$control -P$haproxyPort -uroot  -e "create database sbtest;"
$home/br/bin/br restore full \
    --pd "$pd1:2379" \
    --storage "s3://$tempBR/$size?region=$tempBRRegion&access-key=$ACCESSKEY&secret-access-key=$SECRETKEY" \
    --ratelimit 128 \
    --log-file restorefull.log

sysbench oltp_update_index \
    --threads=8 \
    --time=300 \
    --report-interval=1 \
    --rand-type=uniform \
    --db-driver=mysql \
    --mysql-db=sbtest \
    --mysql-host=$control\
    --mysql-port=$haproxyPort \
    --mysql-user=root \
    run --tables=16 --table-size=$size
echo "update_index"

mysql -h$control -P$haproxyPort -uroot  -e "drop database sbtest;"
mysql -h$control -P$haproxyPort -uroot  -e "create database sbtest;"
$home/br/bin/br restore full \
    --pd "$pd1:2379" \
    --storage "s3://$tempBR/$size?region=$tempBRRegion&access-key=$ACCESSKEY&secret-access-key=$SECRETKEY" \
    --ratelimit 128 \
    --log-file restorefull.log

sysbench oltp_read_only \
    --threads=8 \
    --time=300 \
    --report-interval=1 \
    --rand-type=uniform \
    --db-driver=mysql \
    --mysql-db=sbtest \
    --mysql-host=$control\
    --mysql-port=$haproxyPort \
    --mysql-user=root \
    run --tables=16 --table-size=$size
echo "read_only"

mysql -h$control -P$haproxyPort -uroot  -e "drop database sbtest;"
mysql -h$control -P$haproxyPort -uroot  -e "create database sbtest;"
$home/br/bin/br restore full \
    --pd "$pd1:2379" \
    --storage "s3://$tempBR/$size?region=$tempBRRegion&access-key=$ACCESSKEY&secret-access-key=$SECRETKEY" \
    --ratelimit 128 \
    --log-file restorefull.log

sysbench oltp_read_write \
    --threads=8 \
    --time=300 \
    --report-interval=1 \
    --rand-type=uniform \
    --db-driver=mysql \
    --mysql-db=sbtest \
    --mysql-host=$control\
    --mysql-port=$haproxyPort \
    --mysql-user=root \
    run --tables=16 --table-size=$size
    echo "read_write"