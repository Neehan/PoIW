# install docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce docker-ce-cli containerd.io
# confirm docker is installed
docker --version
# start docker daemon
sudo service docker start


# get k3s
curl -sfL https://get.k3s.io | sh -
sudo apt-get update
sudo apt-get install kmod


# run k3s
sudo /usr/local/bin/k3s server --snapshotter=fuse-overlayfs &

# install tailscale
curl -fsSL https://tailscale.com/install.sh | sh

