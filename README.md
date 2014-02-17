# Openfire Docker Container

This will build a vanilla installation of [Openfire](http://www.igniterealtime.org/projects/openfire/index.jsp)
inside of a [Docker](http://docker.io) container.  Because Openfire wants persistent data, I've copied over
the vanilla contents of `/var/lib/openfire` and `/etc/openfire` to be mounted as persistent volumes. 

## Building The Container

If you prefer to build the container yourself, you'll need to do some prep work.

1. Enter the `build` directory.
2. Download Openfire from [here](http://www.igniterealtime.org/downloads/index.jsp#openfire) and place it 
in this directory.  If it's not version 3.9.1, edit `Dockerfile` to reflect the correct name
of the file in the `ADD` statement.
3. Edit `docker.conf` and adjust the username/password or port for where `supervisord` listens for web
control of its processes.  If you don't want this feature, remove that section of the conf file.
4. Run `docker build` and optionally give it a tag that you like.  

## Running The Container

1. From within the `run` directory, optionally edit the `run.sh` file to change the tag for the 
container.  
2. Execute `run.sh` to kick off the container.  This will mount the `etc` and `lib` directories in their
appropriate places, chown their contents to the openfire user and start Openfire under `supervisord`.  
You'll be able to connect by opening a browser and going to [https://localhost:9091](https://localhost:9090).
As long as you start future iterations of the container from this directory, changes to the configuration,
plugins, and the embedded database will be preserved.
3. If you want to restart Openfire without restarting the entire container, you can do so via the web
interface to `supervisord`, which is running on port 9999.  

## Uprading The Container

When the time comes to upgrade the container, it's quite simple.

1.  Stop and remove the existing container with `docker kill` and `docker rm`.  All of your data is
persistent.
2.  Make a backup of `run/etc/` and `run/lib/` just in case something goes south.
3.  Follow the build steps from above for the latest version of Openfire.
4.  Start your new container.
5.  If everything went well, remove the backups.

