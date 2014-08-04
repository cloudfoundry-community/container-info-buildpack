container-info-buildpack
========================

A buildpack that allows exploring around the Cloud Foundry runtime container.  Useful when creating other buildpacks to discover the staging and runtime environment setup / restrictions

It use:
 - for web-ui part:
  - [AngularJS](https://angularjs.org/) (for [MVVM](http://khanlou.com/2014/03/model-view-whatever/))
  - [Bower](http://bower.io/) (a package manager for the web)
  - [Grunt](http://gruntjs.com/) (a javascript task runner)
  - [Openresty](http://openresty.org/) (Nginx server with lua scripting)
 - for buildpack himself
  - [Forego](https://github.com/ddollar/forego) (a [foreman](https://github.com/ddollar/foreman) port in go, foreman is use to run `Procfile`)

_NB!_ By default login for the web-ui is `admin/admin` feel free to change it by placing a `.htpasswd` at your root app folder. (Prefer use the command `htpasswd` to create this file)

### Using

Push a new "empty" app
```bash
$ mkdir container_info && cd container_info
$ touch container-info
$ cf push container-info-test -m 64M  -b https://github.com/cloudfoundry-community/container-info-buildpack.git
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

## Rebuild web-ui in the buildpack

If you are contributing on the buildpack and particulary in the web-ui part you will have some trouble.
You should know that you must work on `web-ui/app` not the `dist` one.

When you finished to work on the web-ui you need to package it to make it go in `dist` folder to do this you need 3 things:

 - First install [node.js](http://nodejs.org/)
 - Install `bower` with npm with this command `npm install -g bower`
 - Install `grunt` with npm with this command `npm install -g grunt`

Ok now you have your tools, next step is to go in command line to the folder `web-ui`.
And now do these commands:
```bash
$ npm install
$ bower install
$ grunt --force
```

Your dist folder is ready to be use, you've done.

## Contributing

Feel free to fork this project and post issues or/and pull request on the side of this page.

