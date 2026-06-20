# Domain Name System Standards

## External Records

| External Domain | Use Case | Human-Friendly |
| ---             | ---      | ---            |
| bluebotpc.com   | SHOULD be used for endpoints exposed to Customers and vendors | Yes |

## Internal Records

| Internal Domain | Use Case | Human-Friendly |
| ---             | ---      | ---            |
| bluebotpc.net   | SHOULD be used for domain-joined systems | No |
| goobyfrs.net    | SHOULD be used for PRIVATE systems | No |

### Time to Live

DNS Records **should** have a TTL of no less than 5 and no greater than 8600.
