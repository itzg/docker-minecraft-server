groupadd --gid 1000 minecraft
groupadd --gid 1001 service-group
useradd --system --shell /bin/false --uid 1000 -g minecraft --home /data minecraft
useradd --system --shell /bin/false --uid 1001 -g service-group -M service-account
