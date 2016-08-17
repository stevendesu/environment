# WIDTH passed to all tmux status bar scripts for responsiveness
WIDTH=$1

# Variables we display and the screen sizes we display them on:
#
# Screen Size (WxH):     SMALL
# CPU / MEM Load:        SMALL
# Current Time:          SMALL -- HH:mm
# Ping to Server:        SMALL -- I want this, but could not find a good way to do it... I tried "ping $(who am i | awk '{print $5}')" but it didn't work
# Current Host:          MEDIUM
# WAN IP Address:        MEDIUM
# Current Username:      LARGE
# Current Active Window: LARGE
# Current Active Pane:   LARGE
# New Mail:              LARGE
# HTTP Server Status:    LARGE
# Current Date:          LARGE
# Operating System:      XLARGE
# Uptime:                XLARGE
# Weather:               XLARGE
# Time:                  XLARGE -- HH:mm:ss

# We need to compute these for all screen sizes

# CPU Load (%)
pcpu=$(ps -Ao pcpu | awk '{sum = sum + $1}END{printf "%4.1f", sum}')

# MEM load (KB)
mem=$(ps -Ao rss | awk '{sum = sum + $1}END{print sum}')

# Total MEM (KB)
tmem=$(cat /proc/meminfo | awk '/MemTotal/ {print $2}')

# We need to compute these only for large and up
if [ $WIDTH -ge $MEDIUM_SCREEN ]; then

  # New mail
  mail=$(~/.tmux.d/helpers/mail.sh)

  # HTTP status
  http=$(netstat -tln | grep ":80" > /dev/null && echo -n "true")

fi

# We need to compute these only for xlarge
#if [ $WIDTH -ge $LARGE_SCREEN ]; then

  # Weather
#  weather=$(~/.tmux.d/helpers/weather.sh)

#fi

# Helper function to convert KB to K/M/G/T
human_print() {
  # We start with KB from /proc/meminfo and ps
  [ $1 -lt 16384 ] && echo "${KB} K" && return
  MB=$((($1+512)/1024))
  [ $MB -lt 16384 ] && echo "${MB} M" && return
  GB=$(((MB+512)/1024))
  [ $GB -lt 16384 ] && echo "${GB} G" && return
  TB=$(((GB+512)/1024))
  [ $TB -lt 16384 ] && echo "${TB} T" && return
}

print_bars() {
  local int=${1%.*}
  local cur=$(($int*10/$2))
  local cnt=0
  while [ $cur -gt 0 ]; do
    [ $cnt -lt 3 ] && echo -n "#[fg=colour2]"
    [ $cnt -gt 2 -a $cnt -lt 7 ] && echo -n "#[fg=colour3]"
    [ $cnt -gt 5 ] && echo -n "#[fg=colour1]"
    echo -n '|'
    cnt=$(($cnt + 1))
    cur=$(($cur - 1))
  done
  while [ $cnt -lt 10 ]; do
    echo -n ' '
    cnt=$(($cnt + 1))
  done
  echo -n "#[fg=colour0]"
}

if [ $WIDTH -lt 40 ]; then
  # Special case: "VERY small" view?
  # Don't even try to display CPU / MEM
  echo "$(date +%R)"
fi
if [ $WIDTH -lt $SMALL_SCREEN -a $WIDTH -ge 40 ]; then
  # "Small" view
  pmem=$(awk -v m=$mem -v t=$tmem 'BEGIN{printf "%3.1f", (m*100/t)}')
  echo "CPU $pcpu% MEM $pmem% | $(date +%R)"
fi
if [ $WIDTH -ge $SMALL_SCREEN -a $WIDTH -lt $MEDIUM_SCREEN ]; then
  # "Medium" view
  pmem=$(awk -v m=$mem -v t=$tmem 'BEGIN{printf "%3.1f", (m*100/t)}')
  echo "CPU $pcpu% MEM $pmem% | $(date +%R)"
fi
if [ $WIDTH -ge $MEDIUM_SCREEN -a $WIDTH -lt $LARGE_SCREEN ]; then
  # "Large" view
  if [ "$http" = "true" ]; then
    httpcolor="#[fg=colour2]"
  else
    httpcolor="#[fg=colour1]"
  fi
  echo "CPU $pcpu% MEM $(human_print $mem) / $(human_print $tmem) | HTTP $httpcolor###[fg=colour0] | $(date +%T)"
fi
if [ $WIDTH -ge $LARGE_SCREEN ]; then
  # "XLarge" view
  if [ "$http" = "true" ]; then
    httpcolor="#[fg=colour2]"
  else
    httpcolor="#[fg=colour1]"
  fi
  echo "CPU: $pcpu% [$(print_bars $pcpu 100)] MEM: $(human_print $mem) / $(human_print $tmem) [$(print_bars $mem $tmem)] | HTTP $httpcolor###[fg=colour0] | $(date +%r)"
fi
