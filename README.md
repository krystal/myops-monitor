# MyOps Monitor

This is a small service that can monitor a MyOps installation to ensure that it is running correctly.

## Configuration

- `MYOPS_HOST` - the hostname of the MyOps installation
- `SLEEP_TIME` - the time (in seconds) to sleep between checks (default: 60 seconds)
- `ISSUE_TOLERANCE` - the number of issues to tolerate before alerting (default: 3)
- `ALERT_RECIPIENTS` - a list of people to email
- `SMTP_HOST`
- `SMTP_USERNAME`
- `SMTP_PASSWORD`
- `ALERT_FROM_ADDRESS` - the address to send emails from (default: myops@example.com)
