# WIDTH passed to all tmux status bar scripts for responsiveness
WIDTH=$1
SMALL=80
MEDIUM=140

# Determine CPU load
pcpu=$(ps -Ao pcpu | awk '{sum = sum + $1}END{printf "%4.1f", sum}')

# Determine MEM load
mem=$(ps -Ao rss | awk '{sum = sum + $1}END{print sum}')

# Determine total MEM
tmem=$(cat /proc/meminfo | awk '/MemTotal/ {print $2}')

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
#    [ $cnt -lt 3 ] && tput setaf 2
#    [ $cnt -gt 2 -a $cnt -lt 7 ] && tput setaf 3
#    [ $cnt -gt 5 ] && tput setaf 1
    echo -n '|'
    cnt=$(($cnt + 1))
    cur=$(($cur - 1))
  done
#  tput sgr0
  while [ $cnt -lt 10 ]; do
    echo -n ' '
    cnt=$(($cnt + 1))
  done
}

# Output: CPU $pcpu [|||   ] - MEM $mem / $tmem [|||   ]
if [ $WIDTH -gt $MEDIUM ]; then
  # "Large" view
  echo "CPU $pcpu [$(print_bars $pcpu 100)] - MEM $(human_print $mem) / $(human_print $tmem) [$(print_bars $mem $tmem)]"
else
  if [ $WIDTH -gt $SMALL ]; then
    # "Medium" view
    echo "CPU: $pcpu% - MEM: $(human_print $mem) / $(human_print $tmem)"
  else
    # "Small" view
    pmem=$(awk -v m=$mem -v t=$tmem 'BEGIN {printf "%3.1f", m*100/t}')
    echo "CPU $pcpu% MEM $pmem%"
  fi
fi
