#!/bin/bash

##cd to the emacs source directory to make things easier
cd $HOME/emacs-ng/

## still not sure what the point of this is
./autogen.sh

## set configuration options
./configure \
	--enable-link-time-optimization \
	--with-native-compilation \
	--with-sound=alsa \
	--with-webrender

## actually build emacs
make -j$(nproc) # proc for number of processors (cores)
## install the emacs binary
##TODO: figure out a way to only call with sudo if it needs it
sudo make install

## go back to the previous directory after we're all done
cd -1
