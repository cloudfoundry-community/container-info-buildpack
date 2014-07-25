container-info-buildpack
========================

A buildpack that allows exploring around the Cloud Foundry runtime container.  Useful when creating other buildpacks to discover the staging and runtime environment setup / restrictions

_NB!_ The app you deploy has *no* security.  Make sure you delete it when you are finished exploring

### Using

Push a new "empty" app
```
$ mkdir container_info && cd container_info
$ touch killroy_was_here
$ cf push --buildpack=git://github.com/cloudfoundry-community/container-info-buildpack.git --memory=64 --instances=1 --no-bind-services --no-create-services

Name> container-info-test

Creating container-info-test... OK

1: container-info-test
2: none
Subdomain> container-info-test

1: de.a9sapp.eu
2: none
Domain> de.a9sapp.eu

Binding container-info-test.de.a9sapp.eu to container-info-test... OK
Save configuration?> n

Uploading container-info-test... OK
Preparing to start container-info-test... OK
-----> Downloaded app package (4.0K)
Initialized empty Git repository in /tmp/buildpacks/container-info-buildpack.git/.git/
-----> Download and unpack packages into app/vendor/
       Installing ForeGo (latest from https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego)
       Installing OpenResty (Nginx app server) 1.2.8.6
       Fixing luajit/lib symlinks...
/tmp/staged/app/vendor/openresty/luajit/lib /tmp/staged
/tmp/staged
       Installing Ohai
       Building native extensions.  This could take a while...
       Successfully installed systemu-2.5.2
       Successfully installed yajl-ruby-1.1.0
       Successfully installed mixlib-cli-1.3.0
       Successfully installed mixlib-config-2.0.0
       Successfully installed mixlib-log-1.6.0
       Successfully installed mixlib-shellout-1.2.0
       Successfully installed ipaddress-0.8.0
       Successfully installed ohai-6.18.0
       8 gems installed
       Installing web-ui
-----> Setup startup options (Procfile & .env)
-----> Uploading droplet (12M)
Checking status of app 'container-info-test'...
  1 of 1 instances running (1 running)
Push successful! App 'container-info-test' available at http://container-info-test.de.a9sapp.eu

```

## Cloud Foundry Extensions - Offline Mode

The primary purpose of extending the heroku buildpack is to cache system dependencies for firewalled or other non-internet accessible environments. This is called 'offline' mode.

'offline' buildpacks can be used in any environment where you would prefer the dependencies to be cached instead of fetched from the internet.

The list of what is cached is maintained in [bin/package](bin/package).

Using cached system dependencies is accomplished by overriding curl during staging. See [bin/compile](bin/compile#L44-48)


## Building
1. Make sure you have fetched submodules

  ```bash
  git submodule update --init
  ```

1. Build the buildpack

  ```bash
  bin/package [ online | offline ]
  ```

1. Use in Cloud Foundry

    Upload the buildpack to your Cloud Foundry and optionally specify it by name

    ```bash
    cf create-buildpack container-info-offline container-info_buildpack-offline-v.zip 1
    cf push my_app -b container-info-offline
    ```

## UI

Giving you a web app through which you can "explore" the container environment

![Web UI](https://f.cloud.github.com/assets/227505/1314712/904f38ba-327a-11e3-97ea-0698d80a82b9.png)

