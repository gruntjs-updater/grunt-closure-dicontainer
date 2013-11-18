# grunt-closure-dicontainer
[![Build Status](https://secure.travis-ci.org/steida/grunt-closure-dicontainer.png?branch=master)](http://travis-ci.org/steida/grunt-closure-dicontainer) [![Dependency Status](https://david-dm.org/steida/grunt-closure-dicontainer.png)](https://david-dm.org/steida/grunt-closure-dicontainer) [![devDependency Status](https://david-dm.org/steida/grunt-closure-dicontainer/dev-status.png)](https://david-dm.org/steida/grunt-closure-dicontainer#info=devDependencies)

> DI Container for Google Closure with automatic registration and strongly typed object graph resolving.

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-closure-dicontainer --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-closure-dicontainer');
```

## The "closure_dicontainer" task

### Overview
In your project's Gruntfile, add a section named `closure_dicontainer` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  closure_dicontainer: {
    app: {
      options: {
        resolve: ['app.A']
      },
      files: {
        'client/app/js/dicontainer.js': 'client/deps.js'
      }
    }
  }
})
```

### Options

#### options.name
Type: `String`
Default value: `app.DiContainer`

Generated DI container name. You have to require it in your app.
```goog.require('app.DiContainer');```

#### options.prefix
Type: `String`
Default value: `../../../../`

Prefix for `deps.js`.

#### options.resolve
Type: `Array.<string>`
Default value: `['este.App']`

Array of types to be resolved. For each type factory with the same name is
creted as instance method in DI container class.

### Usage Examples

How to use DI container in you app.

```js
goog.provide('app.start');

goog.require('app.DiContainer');

/**
 * @param {Object} data Server side data.
 */
app.start = function(data) {
  var container = new app.DiContainer(data);
  // Resolve all dependencies.
  container.esteApp();
};

goog.exportSymbol('app.start', app.start);
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_
