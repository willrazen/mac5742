sudo yum -y update

# paths
ENV=/home/ec2-user/environment/mac5742
cd ${ENV}/miniep1

# get info
INFO=env_info.txt
cat /etc/os-release > ${INFO}
cat /proc/version >> ${INFO}
go version > ${INFO}
python3 --version >> ${INFO}
cat /proc/cpuinfo >> ${INFO}
grep -i bogomips /proc/cpuinfo

# install hyperfine
VER=v1.13.0
ARQ=x86_64-unknown-linux-musl
mkdir -p tmp
wget https://github.com/sharkdp/hyperfine/releases/download/${VER}/hyperfine-${VER}-${ARQ}.tar.gz -O tmp/hyperfine.tar.gz
tar -xzvf tmp/hyperfine.tar.gz -C tmp
mkdir -p hyperfine
mv tmp/hyperfine-${VER}-${ARQ}/* hyperfine/
git clone https://github.com/sharkdp/hyperfine.git tmp/repo
mv tmp/repo/scripts/ hyperfine/
rm -rf tmp

# install misc
pip3 install numpy matplotlib scipy
sudo yum install -y graphviz
#git clone https://github.com/brendangregg/FlameGraph.git
go get github.com/vpxyz/xorshift
go get golang.org/x/perf/cmd/benchstat
go get golang.org/x/tools/cmd/benchcmp