#!/bin/sh
# Prints SSH client latency for use in the tmux status bar on macOS and Linux.
# Tries ICMP ping first, falls back to timing a TCP connect to port 22 on the client.
client_ip=$(echo "$SSH_CONNECTION" | awk '{print $1}')
if [ -z "$client_ip" ]; then
  echo "local"
  exit 0
fi

# BSD (macOS) and Linux spell a one-second timeout differently.
# On Linux, ping -t sets the TTL, and on macOS, nc -w does not limit the connect.
case "$(uname)" in
  Darwin)
    ping_timeout="-t1"
    nc_timeout="-G1"
    ;;
  *)
    ping_timeout="-W1"
    nc_timeout="-w1"
    ;;
esac

latency=$(ping -c1 $ping_timeout "$client_ip" 2>/dev/null | grep 'time=' | sed 's/.*time=\([^ ]*\).*/\1/')
if [ -n "$latency" ]; then
  echo "${latency}ms"
  exit 0
fi

# Prints the current time in milliseconds. BSD date has no %N, so macOS uses python3.
now_ms() {
  ns=$(date +%s%N 2>/dev/null)
  case "$ns" in
    ''|*[!0-9]*) python3 -c 'import time; print(int(time.time() * 1000))' ;;
    *) echo $((ns / 1000000)) ;;
  esac
}

# Fallback: TCP connect timing to client's SSH port (22)
if command -v nc >/dev/null 2>&1; then
  start=$(now_ms)
  if nc -z $nc_timeout "$client_ip" 22 >/dev/null 2>&1; then
    end=$(now_ms)
    echo "$((end - start))ms"
    exit 0
  fi
fi

echo "?ms"
