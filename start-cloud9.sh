if [ ! -z "$C9_USER" ]; then sudo usermod -l $C9_USER ubuntu; fi
node c9sdk/server.js -l 0.0.0.0 -p 9999 -a "$C9_USER":"$C9_PASS" -w /workspace