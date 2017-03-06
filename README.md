# MyOps Monitor

This is a small service that can monitor a MyOps installation to ensure that it is running correctly.

## Installation

1. `[sudo] gem install bundler procodile`
2. `git clone https://github.com/adamcooke/myops-monitor`
3. `cd myops-monitor`
4. `bundle install`
5. `procodile start`

## Configuration

Configuration should be placed in the `config.yml` file in the root of your application. It should contain of all the following directives.

```yaml
myops:
  # The hostname of your MyOps installation
  host: myops.example.com
  # The port that you installation runs on
  port: 443
  # Is SSL required?
  ssl: true
  # An API key which is able to access your installation's meta/status method.
  api_key: abc123abc123abc

smtp:
  # SMTP configuration (passed to the mail gem so supported the same options)
  address: localhost
  username: null
  password: null

checker:
  # Length of time to wait between checks
  sleep: 60

alerts:
  # After how many sequential failed checks should an alert be sent
  sequence: 3
  # Who alerts should be sent from
  from: MyOpos Monitor <myops-monitor@example.com>
  # An array of recipients
  recipients:
    - youremail@example.com
    - anotheremail@example.com
```
