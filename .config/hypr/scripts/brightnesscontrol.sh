#!/usr/bin/env sh

print_error() {
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

get_brightness() {
  brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat
}

get_brightness_info(){
  brightnessctl info | awk -F "'" '/Device/ {print $2}'
}

case $1 in
  i) brightnessctl set +5% ;;
  d) brightnessctl set 5%- ;;
  *) print_error ;;
esac

