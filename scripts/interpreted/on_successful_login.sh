#!/bin/sh
setsid -f swhks -c '/etc/swhkd/swhkdrc'&
pkexec swhkd&
sway&
/usr/lib/kdeconnectd&
fnott&
