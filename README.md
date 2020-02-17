# perl-dkim-sign

Signs mail based on a simple configuration file.

# Requirements

This script depends on YAML and Mail::DKIM.

For CentOS systems, these can be installed by:
```
yum install perl-YAML perl-Mail-DKIM
```

# Usage

```
cat message | dkim_sign.pl
```

# Configuration

The configuration file uses YAML. It is an array of the following map-like structure:

* ***domain*** - The domain to sign
* ***keyfile*** - The keyfile to use for signing.
* ***method*** - The DKIM method (default: relaxed)
* ***selector*** - The DKIM selector (default: dkim)
* ***algorithm*** - The DKIM signing algorithm (default: rsa-sha1)

An example of the configuration file:
```
- domain: example.org
  keyfile: /etc/pki/key.pem
  method: relaxed
  algorithm: rsa-sha1
  selector: dkim
- domain: example.net
  keyfile: /etc/pki/key.pem
```
