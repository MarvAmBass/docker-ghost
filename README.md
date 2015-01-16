# Docker NodeJS Container (marvambass/ghost)
_maintained by MarvAmBass_

[FAQ - All you need to know about the marvambass Containers](http://marvin.im/posts/IT/Docker/marvambass/FAQ__All_you_need_to_know_about_the_marvambass_Containers.html)

## What is it

This Dockerfile (available as ___marvambass/ghost___) gives you a production Ghost Blog Container.

To configure the Container you use environment Variables.

It's based on the [marvambass/nodejs](https://registry.hub.docker.com/u/marvambass/nodejs/) Image

View in Docker Registry [marvambass/ghost](https://registry.hub.docker.com/u/marvambass/ghost/)

View in GitHub [MarvAmBass/docker-ghost](https://github.com/MarvAmBass/docker-ghost)

## Environment variables and defaults

### Ghost Variables

* __GHOST\_LISTEN\_IP__
 * default: _0.0.0.0_

* __GHOST\_URL__
 * default: _http://localhost_ - just set this to your Blog URL like _https://www.myblog.com/blog_

* __GHOST\_MAIL__
 * default: not set - you need to add a complete _Ghost_ mail configuration here
 * this it how it later will be used inside the config: _mail: {$GHOST\_MAIL},_
 * [more about email here](http://support.ghost.org/config/#email)
 
### Inherited Variables

* __NODE\_Version__ (from marvambass/nodejs)
 * optional - if not set, the container uses the stable version it downloaded at container build
 * set this to any NodeJS Version supported by _creationix/nvm_ for example 'NODE_VERSION=v0.10.0'
 * there is also something special here, if you want the absolutly current version of the current time, you can use 'NODE_VERSION=stable' and the current stable version will be downloaded
 
## Exposed Ports

* __2368__
 * port where _Ghost_ listens by default
 
## Volume Paths

* __/ghost/content__
 * the complete content and sqlite database is stored here
 
* __/ghost/config.js__
 * to overwrite the default config and use your own - it is recommented to do this read-only (__:ro__)
 
## Usage

You can just start your Ghost Blog with this Container. Take a look at the Examples below to find out some specials about this container.

Have Fun! And don't forget to go through the initial configuration with your browser - or anyone else might do it ;)

### Examples

The simples way:

    docker run -d -p 80:2368 -v /var/ghost:/ghost/content -e 'GHOST_URL=http://example.com/blog' marvambass/ghost

If you want to use your own _config.js_

    docker run -d -p 80:2368 -v /var/ghost/content:/ghost/content -v /var/ghost/config.js:/ghost/config.js:ro -e 'GHOST_URL=http://example.com/blog' marvambass/ghost
