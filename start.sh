#!/bin/bash -eo pipefail

[ -d "$RUNDIR" ] || mkdir "$RUNDIR"
chown haproxy:haproxy "$RUNDIR"
chmod 2775 "$RUNDIR"

if [ ! -z "$PIPEWORK"]
then
  /usr/bin/pipework --wait
fi

export ETCD_PORT=${ETCD_PORT:-4001}
export HOST_IP=${HOST_IP:-172.17.42.1}
export ETCD=$HOST_IP:4001

echo "[haproxy-confd] booting container. ETCD: $ETCD"

# Loop until confd has updated the haproxy config
until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/haproxy.toml; do
  echo "[haproxy-confd] waiting for confd to refresh haproxy.cfg"
  sleep 5
done

# Run confd in the background to watch the upstream servers
confd -interval 10 -node $ETCD -config-file /etc/confd/conf.d/haproxy.toml
