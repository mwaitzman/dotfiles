#!/bin/sh
swaymsg -t get_tree | jq -r '.. | Select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp
