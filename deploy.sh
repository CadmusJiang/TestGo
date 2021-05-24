[[ -s "$GVM_ROOT/scripts/gvm" ]] && source "$GVM_ROOT/scripts/gvm"
gvm use go1.16

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
haproxyPort="4000"
# compile pd、tidb
cd $home/tidb
make
cd $home/pd
make

ssh root@$pd1 "pkill -f pd-server"
ssh root@$pd1 "rm -rf /tmp/*"
ssh root@$pd1 "rm -rf /root/bin"
ssh root@$pd2 "pkill -f pd-server"
ssh root@$pd2 "rm -rf /tmp/*"
ssh root@$pd2 "rm -rf /root/bin"
ssh root@$pd3 "pkill -f pd-server"
ssh root@$pd3 "rm -rf /tmp/*"
ssh root@$pd3 "rm -rf /root/bin"

ssh root@$tikv1 "pkill -f tikv-server"
ssh root@$tikv1 "rm -rf /tmp/*" 
ssh root@$tikv1 "rm -rf /root/tikv-server"
ssh root@$tikv2 "pkill -f tikv-server"
ssh root@$tikv2 "rm -rf /tmp/*"
ssh root@$tikv2 "rm -rf /root/tikv-server"
ssh root@$tikv3 "pkill -f tikv-server"
ssh root@$tikv3 "rm -rf /tmp/*"
ssh root@$tikv3 "rm -rf /root/tikv-server"

ssh root@$tidb1 "pkill -f tidb-server"
ssh root@$tidb1 "rm -rf /tmp/*"
ssh root@$tidb1 "rm -rf /root/bin"
ssh root@$tidb2 "pkill -f tidb-server"
ssh root@$tidb2 "rm -rf /tmp/*"
ssh root@$tidb2 "rm -rf /root/bin"
ssh root@$tidb3 "pkill -f tidb-server"
ssh root@$tidb3 "rm -rf /tmp/*"
ssh root@$tidb3 "rm -rf /root/bin"

#cp pd,tidb bin

scp -r $home/pd/bin root@$pd1:/root
scp -r $home/pd/bin root@$pd2:/root
scp -r $home/pd/bin root@$pd3:/root

scp -r $home/tidb/bin root@$tidb1:/root
scp -r $home/tidb/bin root@$tidb2:/root
scp -r $home/tidb/bin root@$tidb3:/root

#generate init.sh

cat <<EOF > pd1.sh
nohup /root/bin/pd-server --name=pd1 --data-dir=/tmp/pd/data --client-urls="http://$pd1:2379" --peer-urls="http://$pd1:2380" --initial-cluster="pd1=http://$pd1:2380,pd2=http://$pd2:2380,pd3=http://$pd3:2380" --log-file=/tmp/pd/log/pd.log >nohup.out 2>&1 &
EOF
chmod a+x pd1.sh
cat <<EOF > pd2.sh
nohup /root/bin/pd-server --name=pd2 --data-dir=/tmp/pd/data --client-urls="http://$pd2:2379" --peer-urls="http://$pd2:2380" --initial-cluster="pd1=http://$pd1:2380,pd2=http://$pd2:2380,pd3=http://$pd3:2380" --log-file=/tmp/pd/log/pd.log >nohup.out 2>&1 &
EOF
chmod a+x pd2.sh
cat <<EOF > pd3.sh
nohup /root/bin/pd-server --name=pd3 --data-dir=/tmp/pd/data --client-urls="http://$pd3:2379" --peer-urls="http://$pd3:2380" --initial-cluster="pd1=http://$pd1:2380,pd2=http://$pd2:2380,pd3=http://$pd3:2380" --log-file=/tmp/pd/log/pd.log >nohup.out 2>&1 &
EOF
chmod a+x pd3.sh


#cp init.sh
scp -r ./pd1.sh root@$pd1:/root/bin
scp -r ./pd2.sh root@$pd2:/root/bin
scp -r ./pd3.sh root@$pd3:/root/bin
ssh root@$pd1 "/root/bin/pd1.sh" 
ssh root@$pd2 "/root/bin/pd2.sh" 
ssh root@$pd3 "/root/bin/pd3.sh" 

sleep 30s
echo "-------------------------------------"
ssh root@$pd1 "tail -n 5 /tmp/pd/log/pd.log"
echo "-------------------------------------"
ssh root@$pd2 "tail -n 5 /tmp/pd/log/pd.log"
echo "-------------------------------------"
ssh root@$pd3 "tail -n 5 /tmp/pd/log/pd.log"
echo "-------------------------------------"

TIKV_VERSION=v5.0.0
GOOS=linux  # only {darwin, linux} are supported
GOARCH=amd64 # only {amd64, arm64} are supported
rm -rf tikv-$TIKV_VERSION-$GOOS-$GOARCH.tar.gz
curl -O  https://tiup-mirrors.pingcap.com/tikv-$TIKV_VERSION-$GOOS-$GOARCH.tar.gz
tar -xzf tikv-$TIKV_VERSION-$GOOS-$GOARCH.tar.gz


scp -r tikv-server root@$tikv1:/root
scp -r tikv-server root@$tikv2:/root
scp -r tikv-server root@$tikv3:/root

cat <<EOF > tikv1.sh
nohup /root/tikv-server --pd-endpoints="$pd1:2379" --addr="$tikv1:20160" --data-dir=/tmp/tikv/data --log-file=/tmp/tikv/log/tikv.log >nohup.out 2>&1 &
EOF
chmod a+x tikv1.sh
cat <<EOF > tikv2.sh
nohup /root/tikv-server --pd-endpoints="$pd2:2379" --addr="$tikv2:20160" --data-dir=/tmp/tikv/data --log-file=/tmp/tikv/log/tikv.log >nohup.out 2>&1 &
EOF
chmod a+x tikv2.sh
cat <<EOF > tikv3.sh
nohup /root/tikv-server --pd-endpoints="$pd3:2379" --addr="$tikv3:20160" --data-dir=/tmp/tikv/data --log-file=/tmp/tikv/log/tikv.log >nohup.out 2>&1 &
EOF
chmod a+x tikv3.sh

scp -r tikv1.sh root@$tikv1:/root
scp -r tikv2.sh root@$tikv2:/root
scp -r tikv3.sh root@$tikv3:/root
ssh root@$tikv1 "/root/tikv1.sh" 
ssh root@$tikv2 "/root/tikv2.sh" 
ssh root@$tikv3 "/root/tikv3.sh"

sleep 30s
echo "-------------------------------------"
ssh root@$tikv1 "tail -n 5  /tmp/tikv/log/tikv.log"
echo "-------------------------------------"
ssh root@$tikv2 "tail -n 5  /tmp/tikv/log/tikv.log"
echo "-------------------------------------"
ssh root@$tikv3 "tail -n 5  /tmp/tikv/log/tikv.log"
echo "-------------------------------------"

cat <<EOF > tidb.sh
nohup /root/bin/tidb-server --store=tikv --path="$pd1:2379,$pd2:2379,$pd3:2379" --log-file=/tmp/tidb.log >nohup.out 2>&1 &
EOF
chmod a+x tidb.sh

scp -r tidb.sh root@$tidb1:/root
scp -r tidb.sh root@$tidb2:/root
scp -r tidb.sh root@$tidb3:/root

ssh root@$tidb1 "/root/tidb.sh" 
ssh root@$tidb2 "/root/tidb.sh" 
ssh root@$tidb3 "/root/tidb.sh"

sleep 30s
echo "-------------------------------------"
ssh root@$tidb1 "tail -n 5  /tmp/tidb.log"
echo "-------------------------------------"
ssh root@$tidb2 "tail -n 5  /tmp/tidb.log"
echo "-------------------------------------"
ssh root@$tidb3 "tail -n 5  /tmp/tidb.log"
echo "-------------------------------------"


yum -y install haproxy
systemctl stop haproxy.service
cat <<EOF > /etc/haproxy/haproxy.cfg
global                                     # 全局配置。
   log         127.0.0.1 local2            # 定义全局的 syslog 服务器，最多可以定义两个。
   chroot      /var/lib/haproxy            # 更改当前目录并为启动进程设置超级用户权限，从而提高安全性。
   pidfile     /var/run/haproxy.pid        # 将 HAProxy 进程的 PID 写入 pidfile。
   maxconn     4000                        # 每个 HAProxy 进程所接受的最大并发连接数。
   user        haproxy                     # 同 UID 参数。
   group       haproxy                     # 同 GID 参数，建议使用专用用户组。
   nbproc      40                          # 在后台运行时创建的进程数。在启动多个进程转发请求时，确保该值足够大，保证 HAProxy 不会成为瓶颈。
   daemon                                  # 让 HAProxy 以守护进程的方式工作于后台，等同于命令行参数“-D”的功能。当然，也可以在命令行中用“-db”参数将其禁用。
   stats socket /var/lib/haproxy/stats     # 统计信息保存位置。

defaults                                   # 默认配置。
   log global                              # 日志继承全局配置段的设置。
   retries 2                               # 向上游服务器尝试连接的最大次数，超过此值便认为后端服务器不可用。
   timeout connect  2s                     # HAProxy 与后端服务器连接超时时间。如果在同一个局域网内，可设置成较短的时间。
   timeout client 30000s                   # 客户端与 HAProxy 连接后，数据传输完毕，即非活动连接的超时时间。
   timeout server 30000s                   # 服务器端非活动连接的超时时间。

listen admin_stats                         # frontend 和 backend 的组合体，此监控组的名称可按需进行自定义。
   bind 0.0.0.0:8080                       # 监听端口。
   mode http                               # 监控运行的模式，此处为 `http` 模式。
   option httplog                          # 开始启用记录 HTTP 请求的日志功能。
   maxconn 10                              # 最大并发连接数。
   stats refresh 30s                       # 每隔 30 秒自动刷新监控页面。
   stats uri /haproxy                      # 监控页面的 URL。
   stats realm HAProxy                     # 监控页面的提示信息。
   stats auth admin:pingcap123             # 监控页面的用户和密码，可设置多个用户名。
   stats hide-version                      # 隐藏监控页面上的 HAProxy 版本信息。
   stats  admin if TRUE                    # 手工启用或禁用后端服务器（HAProxy 1.4.9 及之后版本开始支持）。

listen tidb-cluster                        # 配置 database 负载均衡。
   bind 0.0.0.0:$haproxyPort               # 浮动 IP 和 监听端口。
   mode tcp                                # HAProxy 要使用第 4 层的传输层。
   balance leastconn                       # 连接数最少的服务器优先接收连接。`leastconn` 建议用于长会话服务，例如 LDAP、SQL、TSE 等，而不是短会话协议，如 HTTP。该算法是动态的，对于启动慢的服务器，服务器权重会在运行中作调整。
   server tidb-1 $tidb1:4000 check inter 2000 rise 2 fall 3       # 检测 4000 端口，检测频率为每 2000 毫秒一次。如果 2 次检测为成功，则认为服务器可用；如果 3 次检测为失败，则认为服务器不可用。
   server tidb-2 $tidb2:4000 check inter 2000 rise 2 fall 3
   server tidb-3 $tidb3:4000 check inter 2000 rise 2 fall 3
EOF

systemctl start haproxy.service