## Purpose
Cloudflare provides a free DNS service but there is no DDNS Client for floating IP clients.

Running the DDNS docker container in a NAS/PC to keep updating your IP to cloudflare DNS record via cloudflare API.

## Parameter

- `CF_EMAIL`: Cloudflare login email
- `CF_API_KEY`: Cloudflare API Key
- `CF_ZONE_NAME` Domain Name (eg. google.com)
- `CF_DOMAIN_NAME` Domain or subdomain name (eg. doc.google.com)
- `INTERVAL` Time interval to update (Default `60`)
- `PROXIED` Enable Cloudflare (Default `false`)
## Example

```bash
docker run -d --name cf-ddns -it \
  -e CF_EMAIL=XXX@google.com \
  -e CF_API_KEY=XXXXXXXXXXXX \
  -e CF_ZONE_NAME=google.com \
  -e CF_DOMAIN_NAME=doc.google.com \
  -e INTERVAL=60 \
  -e PROXIED=true \	
gaplo917/tiny-cloudflare-ddns
```