# Only update geo info every 30 minutes
if [ -f ~/.tmux.d/cache/geo.txt ]; then
  if [ $(expr $(date +%s) - 1800) -gt $(stat -c %Y ~/.tmux.d/cache/geo.txt) ]; then
    regrab="true"
  fi
else
  regrab="true"
fi

if [ -n "$regrab" ]; then
  # Get IP address
  if [ -z "$SSH_CLIENT" ]; then
    # SSH_CLIENT is not set... Use local IP
    ip=$(~/.tmux.d/helpers/ip.sh)
  else
    # SSH_CLIENT is set... see if it's valid
    ip=$(echo $SSH_CLIENT | awk '{print $1}')
    while read p; do
      echo $ip | grep -E $p > /dev/null && match="match"
    done < ~/.tmux.d/helpers/reservedips.txt
    if [ -n "$match" ]; then
      ip=$(~/.tmux.d/helpers/ip.sh)
    fi
  fi

  # Get zip code from IP
  curl -s freegeoip.net/csv/$ip | awk -F',' '{print $7}' > ~/.tmux.d/cache/geo.txt
fi

cat ~/.tmux.d/cache/geo.txt
