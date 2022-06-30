#if [ ! -z "$UPID" ]; then sudo usermod -u $UPID ubuntu; fi
#if [ ! -z "$UGID" ]; then sudo usermod -g $UGID ubuntu; fi
#if [ ! -z "$C9_USER" ]; then sudo usermod -l $C9_USER ubuntu; fi
node c9sdk/server.js -l 0.0.0.0 -p 9999 -a : -w /workspace