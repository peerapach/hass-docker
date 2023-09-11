
## Install systemd-journal-remote 
```
apt install systemd-journal-remote
```

Start the service:
```
systemctl enable systemd-journal-gatewayd.service
systemctl start systemd-journal-gatewayd.service
```
