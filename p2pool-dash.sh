#!/bin/bash
set -e

docker=$(which docker)

case "$1" in
  install)
    "$docker" pull thelazier/docker-p2pool-dash:latest
    ;;
  start)
    "$docker" run -d -p 0.0.0.0:7903:7903 -p 0.0.0.0:8999:8999 --env-file=env-mainnet --name p2pool-dash thelazier/docker-p2pool-dash:latest
    ;;
  stop)
    "$docker" stop p2pool-dash
    ;;
  start-testnet)
    "$docker" run -d -p 0.0.0.0:17903:17903 -p 0.0.0.0:8999:8999 --env-file=env-testnet --name p2pool-dash-testnet thelazier/docker-p2pool-dash:latest
    ;;
  stop-testnet)
    "$docker" stop p2pool-dash-testnet
    ;;

  uninstall)
    "$docker" rm p2pool-dash
    "$docker" rm p2pool-dash-testnet
    "$docker" rmi thelazier/docker-p2pool-dash
    ;;
  *)
    echo "Usage: $0 [install|start|stop|start-testnet|stop-testnet|uninstall]"
    exit 1
    ;;
esac

