#Prepare
pd1="172.16.5.170"
pd2="172.16.5.131"
pd3="172.16.4.199"
tikv1="172.16.4.216"
tikv2="172.16.4.158"
tikv3="172.16.4.212"
tidb1="172.16.5.165"
tidb2="172.16.4.179"
tidb3="172.16.4.181"
# FBI WARNING 
# manual operation 
#generate ssh-key
#ssh-keygen -t rsa -P ""
# set ssh
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$pd1
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$pd2
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$pd3
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$tikv1
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$tikv2
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$tikv3
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$tidb1
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$tidb2
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@$tidb3

#Copy the command to the command line and install GVM
#Or if you are using zsh just change bash with zsh
#bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
#zsh  < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
#!!!source terminal output

chmod +x ./download.sh
chmod +x ./compile.sh
chmod +x ./deploy.sh
chmod +x ./generate.sh
chmod +x ./go-tpc.sh
chmod +x ./go-ycsb.sh
chmod +x ./sysbench.sh
go test *_test.go  -bench=. -run=^$
./download.sh
./compile.sh
./deploy.sh


#set warehouse in go-tpc.sh
./go-tpc.sh

#set table line in sysbench.sh
./sysbench.sh

#
./go-ycsb.sh


#generate sysbench data and store in aws s3,now table line include 1k、1w、10w
#./generate