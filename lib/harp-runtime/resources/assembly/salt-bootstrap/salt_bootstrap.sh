#!/bin/bash

mkdir /srv/salt

touch /srv/salt/top.sls

touch /srv/salt/webserver.sls

cat > /srv/salt/top.sls << EOF
base:
  '*':
    - webserver
EOF

echo -e "$packages_yaml" >> /srv/salt/webserver.sls