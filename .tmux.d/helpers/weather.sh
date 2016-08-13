# WIDTH passed to all tmux status bar scripts for responsiveness
WIDTH=$1

# Only update weather every 30 minutes
if [ -f ~/.tmux.d/cache/weather.txt ]; then
  if [ $(expr $(date +%s) - 1800) -gt $(stat -c %Y ~/.tmux.d/cache/weather.txt) ]; then
    regrab="true"
  fi
else
  regrab="true"
fi

if [ -n "$regrab" ]; then
  # Get zip code
  zip=$(~/.tmux.d/helpers/geo.sh)

  # Get weather from zip
  curl -s "http://api.openweathermap.org/data/2.5/weather?zip=$zip,us&APPID=$OPENWEATHER_API_KEY&mode=xml" > ~/.tmux.d/cache/weather.txt
fi

# Extract temperature and weather type for now
weather=$(cat ~/.tmux.d/cache/weather.txt | awk 'BEGIN{RS="<[^>]+>"}{print RT}' | grep "<weather" | awk -F'\"' '{print $4}')
temperature=$(cat ~/.tmux.d/cache/weather.txt | awk 'BEGIN{RS="<[^>]+>"}{print RT}' | grep "<temperature" | awk -F'\"' '{print 1.8*($2-273.15)+32}')

echo $weather
echo $temperature
