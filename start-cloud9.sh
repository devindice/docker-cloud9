#if [ ! -z "$UPID" ]; then sudo usermod -u $UPID ubuntu; fi
#if [ ! -z "$UGID" ]; then sudo usermod -g $UGID ubuntu; fi
if [ ! -z "$C9_USER" ]; then sudo usermod -l $C9_USER ubuntu; sudo useradd --non-unique -u 99 -g ubuntu -d /home/ubuntu -ms /bin/bash ubuntu; fi
mkdir -p /workspace/.ubuntu/.standalone
mkdir -p /workspace/.ubuntu/.c9
ln -sf /workspace/.ubuntu/user.settings /home/ubuntu/.c9/user.settings

node c9sdk/server.js -l 0.0.0.0 -p 9999 -a : -w /workspace
