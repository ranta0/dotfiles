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

3. WSL cannot connect to the internet while in VPN, [solution](https://gist.github.com/mikegerber/91fcea262028e09b2fd0969193c6c260)

```powershell
Set-ItemProperty `
  -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss `
  -Name NatNetwork `
  -Value "169.254.214.0/24"
Set-ItemProperty `
  -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss `
  -Name NatGatewayIpAddress `
  -Value "169.254.214.1"
```
