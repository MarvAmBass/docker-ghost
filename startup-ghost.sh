#!/bin/bash

if [ ! -d /ghost/content/data ]
then
  echo ">> found empty content folder - copy default contents to it..."
  cp -a /ghost/content.bak/* /ghost/content/
fi

if [ ! -e config.js ]
then 
  echo ">> generating config"
  mv config.example.js config.js

  if [ -z ${GHOST_LISTEN_IP+x} ]
  then
    GHOST_LISTEN_IP=0.0.0.0
  fi

  if [ -z ${GHOST_URL+x} ]
  then
    GHOST_URL=http://localhost
  fi
  
  if [ -z ${GHOST_MAIL+x} ]
  then
    GHOST_MAIL=""
  fi

  echo "using the following settings:"
  echo "GHOST_LISTEN_IP = $GHOST_LISTEN_IP"
  echo "GHOST_URL       = $GHOST_URL"
  echo "GHOST_MAIL      = $GHOST_MAIL"

  sed -i "s/host: '127.0.0.1',/host: '$GHOST_LISTEN_IP',/g" config.js
  
  GHOST_URL=$(echo $GHOST_URL | sed 's/\//\\\//g')
  sed -i "s/url: 'http:\/\/my-ghost-blog.com',/url: '$GHOST_URL',/g" config.js
  
  GHOST_MAIL=$(echo $GHOST_MAIL | sed 's/\//\\\//g')
  sed -i "s/mail: {},/mail: {$GHOST_MAIL},/g" config.js
else
  echo ">> use config.js found in container"
fi

if [ ! -z ${GHOST_USERNAME+x} ] && [ ! -z ${GHOST_USERMAIL+x} ]
then
  npm start &
  sleep 15
  
  echo ">> initial setup user, password, title etc."
  
  if [ -z ${GHOST_TITILE+x} ]
  then
    GHOST_TITILE=Ghost
  fi
  
  echo ">>   user: $GHOST_USERNAME"
  echo ">>   email: $GHOST_USERMAIL"
  echo ">>   title: $GHOST_TITILE"

  if [ -z ${GHOST_URL+x} ]
  then
    GHOST_URL=http://localhost
  fi
  
  if [ -z ${GHOST_USERPASSWORD+x} ] || [ 8 -gt ${#GHOST_USERPASSWORD} ]
  then
    echo ">>   invalid password set - using generated one"
    GHOST_USERPASSWORD=`pwgen 10 1`
    echo ">>   pswd: $GHOST_USERPASSWORD"
  else
    echo ">>   pswd: <hidden>"
  fi
  
  curl 'http://127.0.0.1:2368/ghost/api/v0.1/authentication/setup/' \
  --data "setup[0][name]=$GHOST_USERNAME&setup[0][email]=$GHOST_USERMAIL&setup[0][password]=$GHOST_USERPASSWORD&setup[0][blogTitle]=$GHOST_TITILE"
  sleep 5

  echo ">> kill node server"
  kill `ps aux | grep "node index" | head -n1 | awk '{print $2}'`
  sleep 3
  kill `ps aux | grep "node index" | head -n1 | awk '{print $2}'`
  sleep 3
  echo ">> done with setup"
fi

npm start
