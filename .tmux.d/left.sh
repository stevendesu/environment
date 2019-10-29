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

# We need to compute these only for medium and up
if [ $WIDTH -ge $SMALL_SCREEN ]; then

  # WAN IP Address
  ip=$(~/.tmux.d/helpers/ip.sh)

fi

#if [ $WIDTH -ge $LARGE_SCREEN ]; then

  # Operating System
  if [[ "$OSTYPE" == linux* ]]; then
    os=$(lsb_release -a | grep "Desc" | awk '{for(i=2;i<=NF;i++) printf "%s",$i (i==NF?ORS:OFS)}')
  elif [[ "$OSTYPE" == darwin* ]]; then
    os="OS X $(sw_vers -productVersion)"
  fi

  # Uptime
  if [[ "$OSTYPE" == linux* ]]; then
    upt=$(uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {printf "%02d:%02d:%02d:00", d, h, m}')
  elif [[ "$OSTYPE" == darwin* ]]; then
    upt=$(uptime | awk -F'( |,|:)+' '{d=$4; h=$6; m=$7} {printf "%02d:%02d:%02d:00", d, h, m}')
  fi

#fi

if [ $WIDTH -lt $SMALL_SCREEN ]; then
  # "Small" view
  echo "#{client_width}x#{client_height} "
fi
if [ $WIDTH -ge $SMALL_SCREEN -a $WIDTH -lt $MEDIUM_SCREEN ]; then
  # "Medium" view
  echo "#H ($ip) #{client_width}x#{client_height} "
fi
if [ $WIDTH -ge $MEDIUM_SCREEN -a $WIDTH -lt $LARGE_SCREEN ]; then
  # "Large" view
  echo "$(whoami)@#H ($ip) #{client_width}x#{client_height} #W[#P] "
fi
if [ $WIDTH -ge $LARGE_SCREEN ]; then
  # "XLarge" view
  echo "$(whoami)@#H ($ip) [$os] UP: $upt #{client_width}x#{client_height} #W[#P] "
fi
