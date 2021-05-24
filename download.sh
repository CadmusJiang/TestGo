tidb_branch="master"
pd_branch="master"
tidb_binlog_branch="master"
br_branch="master"
ticdc="master"
dm_branch="master"
dumpling_branch="master"
tidb_operator_branch="master"

tidb_commit="58fb30f4d6c65d03cc4b15693e5d78debc68affe"
pd_commit="b6e80b2da010612cfc4adc31f75a9481a3fe052c"
tidb_binlog_commit="53a591e8258a97aefe9f5b705176e4a9d068c59e"
br_commit="31e539ce3824985f79e5ca508bea00a9d9bc52c4"
ticdc_commit="abf01a017a57277a74020dbe5164d398cdf20fca"
dm_commit="ae41881cd42008096841ae6ac04fe31f38222e60"
dumpling_commit="be441d7055c82f605bbac39a215d54af6f9c3596"
tidb_operator_commit="c5c4d59aad5d424db8a33ab175651864a1d3efd6"

GOPATH="/tmp"
rm -rf $GOPATH/src/github.com/pingcap
mkdir -p $GOPATH/src/github.com/pingcap
cd $GOPATH/src/github.com/pingcap
git clone https://github.com/pingcap/tidb.git 
git clone https://github.com/pingcap/pd.git
git clone https://github.com/pingcap/tidb-binlog.git 
git clone https://github.com/pingcap/br.git
git clone https://github.com/pingcap/ticdc.git
git clone https://github.com/pingcap/dm.git
git clone https://github.com/pingcap/dumpling.git
git clone https://github.com/pingcap/tidb-operator.git

cd $GOPATH/src/github.com/pingcap/tidb
git pull origin
git checkout $tidb_branch
#git checkout $tidb_commit 

cd $GOPATH/src/github.com/pingcap/pd
git pull origin
git checkout $pd_branch
#git checkout $pd_commit

cd $GOPATH/src/github.com/pingcap/tidb-binlog
git pull origin
git checkout $tidb_binlog_branch
#git checkout $tidb_binlog_commit

cd $GOPATH/src/github.com/pingcap/br
git pull origin
git checkout $br_branch
#git checkout $br_commit

cd $GOPATH/src/github.com/pingcap/ticdc
git pull origin
git checkout $ticdc_branch
#git checkout $ticdc_commit

cd $GOPATH/src/github.com/pingcap/dm
git pull origin
git checkout $dm_branch
#git checkout $dm_commit

cd $GOPATH/src/github.com/pingcap/dumpling
git pull origin
git checkout $dumpling_branch
#git checkout $dumpling_commit

cd $GOPATH/src/github.com/pingcap/tidb-operator
git pull origin
git checkout $tidb_operator_branch
#git checkout $tidb_operator_commit
