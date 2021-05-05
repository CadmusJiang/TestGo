bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

[[ -s "$GVM_ROOT/scripts/gvm" ]] && source "$GVM_ROOT/scripts/gvm"
gvm install go1.16
gvm use go1.16

home="/Users/cadmusjiang/pingcap"


cd $home/br
make build
echo "br"
echo "------------------------------"

cd $home/dm
make build
echo "dm"
echo "------------------------------"

cd $home/dumpling
make
echo "dumpling"
echo "------------------------------"

cd $home/tidb
make
echo "tidb"
echo "------------------------------"

cd $home/pd
make build
echo "pd"
echo "------------------------------"

cd $home/ticdc
make build
echo "ticdc"
echo "------------------------------"

cd $home/tidb-binlog
make build
echo "tidb-binlog"
echo "------------------------------"

cd $home/tidb-lightning
make
echo "tidb-lightning"
echo "------------------------------"