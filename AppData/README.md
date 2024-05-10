# Useful things on Windows

Mostly WSL related, because I **will** forget:

1. Use kubectl config from Windows, thanks to [cmendible](https://gist.github.com/cmendible/ee6119ee202becd743888435e830b987)

```bash
mkdir -p ~/.kube
ln -sf "/mnt/c/users/$USER/.kube/config" ~/.kube/config
```

2. Kubectl unable to connect to server, tls handshake timeout, when in VPN

```bash
sudo ifconfig eth0 mtu 1350

# or newer versions

sudo ip link set dev eth0 mtu 1350
```
