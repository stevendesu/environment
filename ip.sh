# Only update IP every 10 minutes
if [ $(expr $(date +%s) - 600) -gt $(stat -c %Y ~/.ip) ]; then
  curl -s icanhazip.com > ~/.ip
fi

cat ~/.ip
