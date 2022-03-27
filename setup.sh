sudo yum -y update

# show info
cat /etc/os-release
cat /proc/version
grep -i bogomips /proc/cpuinfo

# install hyperfine
VER=v1.13.0-x86_64-unknown-linux-musl
wget https://github.com/sharkdp/hyperfine/releases/download/v1.13.0/hyperfine-$VER.tar.gz -O hyperfine.tar.gz
tar -xzvf hyperfine.tar.gz
mv hyperfine-$VER/ hyperfine/
git clone https://github.com/sharkdp/hyperfine.git tmp
mv tmp/scripts/ hyperfine/

# clean up
rm -rf tmp hyperfine.tar.gz
