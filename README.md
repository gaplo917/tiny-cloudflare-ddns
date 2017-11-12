## Purpose
Cloudflare is very popular but there is no DDNS Client for home users to update their dynmaic IP.

Running in a NAS/PC to update your dynamic IP to cloudflare DNS record.

## Parameter

- `CF_EMAIL`: Cloudflare login email
- `CF_TOKEN`: Cloudflare API Key
- `CF_ZONE_NAME` Domain Name (eg. google.com)
- `CF_DOMAIN_NAME` Domain or subdomain name (eg. doc.google.com)
- `INTERVAL` Time interval to update (Default `60`)
- `PROXIED` Enable Cloudflare (Default `false`)
## Example

```bash
docker run -it \
  -e CF_EMAIL=XXX@google.com \
  -e CF_API_KEY=XXXXXXXXXXXX \
  -e CF_ZONE_NAME=google.com \
  -e CF_DOMAIN_NAME=doc.google.com \
  -e INTERVAL=60 \
  -e PROXIED=true \	
gaplo917/tiny-cloudflare-ddns
```