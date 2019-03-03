#!/bin/sh

# please first install iio-sensor-proxy ahead

# this script is modified from other's config file
# serves to automatic rotate the screen in certain env

screen="eDP1"                      # get screen by xrandr
device="Wacom HID 482E Finger"     # get device by xinput

monitor-sensor \
  | grep --line-buffered "Accelerometer orientation changed" \
  | grep --line-buffered -o ": .*" \
  | while read -r line; do

      line="${line#??}"

      if [ "$line" = "normal" ]; then
        rotate=normal
        matrix="0 0 0 0 0 0 0 0 0"
      elif [ "$line" = "left-up" ]; then
        rotate=left
        matrix="0 -1 1 1 0 0 0 0 1"
      elif [ "$line" = "right-up" ]; then
        rotate=right
        matrix="0 1 0 -1 0 1 0 0 1"
      elif [ "$line" = "bottom-up" ]; then
        rotate=inverted
        matrix="-1 0 1 0 -1 1 0 0 1"
      fi

      xrandr --output "$screen" --rotate "$rotate"
      xinput set-prop "$device" --type=float "Coordinate Transformation Matrix" $matrix

    done
