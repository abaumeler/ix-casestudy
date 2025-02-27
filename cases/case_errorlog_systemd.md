# ErrorLog SystemD Service

## Overview
This case deploys a systemd unit file called errorlog.service that intentionally writes error messages to a log file.

The service is designed to simulate a failing application that produces error logs for troubleshooting practice.

## Infos for Candidate
### Reported Error
Users are reporting that the ErrorLog application is failing and generating errors. Please investigate the issue and determine what's happening.

### Documentation
There is one server running the ErrorLog service.

ErrorLog is started with `systemctl start errorlog`

ErrorLog will log to `/var/log/errorlog.log`

## Solution
The service is designed to generate error messages for troubleshooting practice. The candidate should:
1. Check the service status with `systemctl status errorlog`
2. Examine the logs with `cat /var/log/errorlog.log` or `tail -f /var/log/errorlog.log`
3. Identify that the service is functioning as designed (generating error messages)
4. Optionally suggest monitoring or alerting solutions to track these errors

## What to Look For
- Ability to navigate linux shell
- Ability to check service status and logs
- Understanding of systemd service management
- Can they identify that the service is working as designed?
- Do they propose any improvements or monitoring solutions?