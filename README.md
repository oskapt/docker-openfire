# Openfire Docker Container

This will build a vanilla installation of [Openfire](http://www.igniterealtime.org/projects/openfire/index.jsp)
inside of a [Docker](http://docker.io) container.  Because Openfire wants persistent data, I've copied over
the vanilla contents of the following directories to be mounted as persistent volumes.

* `/usr/share/openfire/conf`
* `/usr/share/openfire/resources/security`
* `/usr/share/openfire/embedded-db`
* `/usr/share/openfire/plugins`

## Building The Container

If you prefer to build the container yourself, you'll need to do some prep work.

1. Enter the `build` directory.
2. Review the Dockerfile for the version of Openfire that you wish to install. Change the environment variable `OF_VERSION` to match.
3. While you're there, review the version of `dumb-init`. If you need to change it, change the `DI_VERSION` environment variable.
4. . Run `docker build` and optionally give it a tag that you like.

## Running The Container

Copy the contents of the `run` directory to a location on the filesystem from where you run containers.
I keep all container operations under `/opt/docker/<container>`, so for the rest of this document I'll
presume `/opt/docker/openfire`, which I'll refer to as `$rundir`.

### Via Docker Compose

1. From `$rundir`, optionally edit `docker-compose.yml` to change the tag for the
container. 
2. If you don't want to use the admin console over HTTP, remove 9090 from the ports config.
3. Run `docker-compose up` to start the container in the foreground or `docker-compose up -d` to
start it in the background.

### Manually

1. From `$rundir`, optionally edit the `run.sh` file to change the tag for the
container.
2. If you don't want to use the admin console over HTTP, remove 9090 from the ports config.
3. Execute `run.sh` to kick off the container.  This will mount the directories in their
appropriate places, start Openfire, and tail the logfile.

## Connecting To Openfire

You'll be able to connect by opening a browser and going to [http://localhost:9090](http://localhost:9090),
optionally replacing `localhost` with the hostname or IP of your Docker host system.

If you're doing an upgrade and have configured TLS, you'll be able to connect to the admin console over HTTPS on port 9091.

As long as you start future iterations of the container from this directory, changes to the configuration,
plugins, and the embedded database will be preserved.

## Installing SSL Certificates

For ease in installing SSL certificates, see [this post](https://blog.bigdinosaur.org/openfire-and-ssl-slash-tls-certificates/).

Both `KeyStoreImport.java` and `KeyStoreImport.class` are contained in this repository, in the `security` folder. The latter
is provided in case your origin container only provides the JRE.

1. Connect to the container and start a shell

        $ docker run -it monachus/openfire /bin/ash

2. Follow along with the post, changing `/etc/openfire/security` to `/usr/share/openfire/resources/security`

## Uprading The Container (minor versions)

When the time comes to upgrade the container, it's quite simple.

1.  Stop and remove the existing container with `docker kill` and `docker rm`.  All of your data is
persistent.
2.  Make a backup of `$rundir` just in case something goes south.
3.  Follow the build steps from above for the latest version of Openfire.
4.  Start your new container.
5.  If everything went well, remove the backups.

## Upgrading from Openfire 3 to Openfire 4

### Caveats

* `/etc/openfire` is now `/usr/share/openfire/conf`
* There is no more `lib` directory. Plugins are at the top level.
* `/etc/openfire/security` is now `/resources/security` 
* Openfire runs as `daemon` instead of its own user

### Upgrade Steps

1. Backup `lib/embedded-db`, `lib/plugins`, and `etc`
2. Stop and remove the v3 container.
3. Rename your current `$rundir` to `$rundir.old`
3. From this source copy `run` to `$rundir` (creating a new directory)
4. From your backups, copy the following:
   * The contents of `etc/security` to `security`
   * The remaining contents of `etc` to `conf` (excluding the `security` folder)
   * The contents of `lib/plugins` to `plugins` _except_ the `admin` folder
   * The contents of `lib/embedded-db` to `embedded-db`
5. Restart the container via your chosen means
