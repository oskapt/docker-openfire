# Openfire Docker Container

This will build a vanilla installation of [Openfire](http://www.igniterealtime.org/projects/openfire/index.jsp)
inside of a [Docker](http://docker.io) container.  Because Openfire wants persistent data, I've copied over
the vanilla contents of `/var/lib/openfire` and `/etc/openfire` to be mounted as persistent volumes. 

This container also contains a bonus installation of [git-annex](http://git-annex.branchable.com) because why
else would you need to run an XMPP server?  :P

## Download The Container

You can download and run a fully-functional container from the Docker Registry.

```Bash
docker pull monachus/openfire
```

Jump to Running The Container to continue.

## Building The Container

If you prefer to build the container yourself, you'll need to do some prep work.

1. Download Openfire from [here](http://www.igniterealtime.org/downloads/index.jsp#openfire) and place it 
in the `build` directory.  If it's not version 3.8.2, edit `Dockerfile` to reflect the correct name
of the file in the `ADD` statement.
2. Run `docker build` and optionally give it a tag that you like.  For the rest of this document I'll use
`monachus/openfire` as the tag.

## Running the Container

1. From within the `run` directory, optionally edit the `run.sh` file to change the tag for the 
container.  
2. Execute `run.sh` to kick off the container.  This will mount the `etc` and `lib` directories in their
appropriate places, chown their contents to the openfire user and start Openfire under `supervisord`.  
You'll be able to connect by opening a browser and going to [http://localhost:9090](http://localhost:9090).
As long as you start future iterations of the container from this directory, changes to the configuration,
plugins, and the embedded database will be preserved.


