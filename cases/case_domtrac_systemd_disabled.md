# Domtrac SystemD Disabled

## Overview
This case deployes a systemd unit file called domtrac.service

The unit file is disabled - the service will not be running when the machine is restarted

## Infos for Candidate
### Reported Error
Domtrac keeps running until machine is rebooted. After a reboot the service has to be started manually. Please investigate

### Documentation
There are two servers that run domtrac. The IP Adresses of the machines are in a text file on the desktop of the Jump-Host.

Domtrac is started with ```systemctl start domtrac```

Domtrac will log to ```/var/log/domtrac.log```

## Solution
There are multiple paths that can be taken here. One straight forward answer to this problem is to enable the systemd unit with ```systemctl enable domtrac```

## What to Look For
- Ability to navigate linux shell
- Ability to read documentation and apply information to current issue
- Is the application simply started (short term fix until next reboot) or acutally enabled (permanent fix)?
- Is the proposed solution verfied by rebooting the machines?
- Logfiles found and read? If yes - how were they read?


