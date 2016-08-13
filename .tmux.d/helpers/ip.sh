# Only update IP every 30 minutes
if [ -f ~/.tmux.d/cache/ip.txt ]; then
  if [ $(expr $(date +%s) - 1800) -gt $(stat -c %Y ~/.tmux.d/cache/ip.txt) ]; then
    curl -s icanhazip.com > ~/.tmux.d/cache/ip.txt
  fi
else
  curl -s icanhazip.com > ~/.tmux.d/cache/ip.txt
fi

cat ~/.tmux.d/cache/ip.txt
