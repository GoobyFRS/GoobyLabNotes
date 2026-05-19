# Machine Tracker

| **Location** | **Hostname** | **OS**     | **Function 1** | **Function 2** | **Tier** | **Monitoring** | **Patching Cycle** | **IPv4**    | **IPv6** | **Fail2Ban** | **Crowdsec** | **OS EOL** |
| ---          | ---          | ---        | ---            | ---            | ---      | ---            | ---                | ---         | ---      | ---          | ---          | ---        |
| HOME         | truenas      | Dragonfish | Storage        | None           | 0        | None           | 30d                | 192.168.0.X | NoIPv6   | NA           | NA           | NA         |
| HOME         | mediaserver  | bullseye   | Jellyfin       | None           | 0        | Longview       | 30d                | 192.168.0.X | NoIPv6   | Yes          | Yes          | 8-14-2024  |
| HOME         | pi4a         | bookworm   | PiHole         | None           | 1        | None           | 14d                | 192.168.0.X | NoIPv6   | Yes          | Yes          | 6-10-2026  |
| SEA          | mattfaulkner | bookworm   | Caddy          | BBPC Web       | 3        | NewRelic       | 30d                | 172.232.181.204 | 2600:3c0a::f03c:95ff:fe8d:e1d4 | Yes    | Yes | Yes | 6-10-2026 |
| PHX          | uptime       | jammy      | UptimeKuma     | None           | 2        | Longview       | 30d                | 141.148.175.190 | 2603:c020:13:e300:2900:8c33:2ddc:3d58   | Yes | Yes | 4-2027 |
| PHX          | nc2          | jammy      | Nextcloud      | Talk           | 1        | NewRelic       | 30d                | 129.146.70.194  | 	2603:c020:13:e300:1f80:e04d:e581:5697 | Yes | Yes | 4-2025 |
| SANJ         | helpdesk     | jammy      | Helpdesk       | None           | 4        | Longview       | 30d                | 165.1.72.63     | 2603:c024:c013:cd00:49ec:c169:255d:6a1e | Yes | Yes | 4-2025 |

> mediaserver has surpassed Standard EOL. LTS support remains until 8-31-2026
