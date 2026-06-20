# Password and Secrets Management

## Overview

A _secret_ is an object that contains restricted data.

- Active Directory Creds
- Certificate Priv Keys
- Database Passwords
- OAuth API Tokens
- Service API Tokens

### General Requirements

Secrets **must** be rotated one every year.

Secrets are classified as RESTRICTED.

Secrets **must** be encrypted at rest.

Secrets **must** be encryted in transit.

Secrets **must not** appear in Event Logs.

### Internal

User passwords **

### Code Based

### Sharing

Passwords **may** be shared via Bitwarden Send or Encrypted Emai.

NO OTHER METHODS ARE ALLOWED AT THIS TIME.
