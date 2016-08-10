# Determine CPU load
pcpu=$(ps -Ao pcpu | awk '{sum = sum + $1}END{print sum}')

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

# Output: CPU $pcpu [|||   ] - MEM $mem / $tmem [|||   ]
echo CPU $pcpu \[\|\|\| \] - MEM $(human_print $mem) / $(human_print $tmem) \[\|\|\| \]
#echo $mem / $tmem = $(($mem * 10 / $tmem))
#printf "|%.0s" {1..$pcpu}
