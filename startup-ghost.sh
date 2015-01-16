#!/bin/bash

if [ ! -d /ghost/content/data ]
then
  echo ">> found empty content folder - copy default contents to it..."
  cp -a /ghost/content.bak /ghost/content
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

npm start
