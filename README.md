# grunt-closure-dicontainer
[![Build Status](https://secure.travis-ci.org/steida/grunt-closure-dicontainer.png?branch=master)](http://travis-ci.org/steida/grunt-closure-dicontainer) [![Dependency Status](https://david-dm.org/steida/grunt-closure-dicontainer.png)](https://david-dm.org/steida/grunt-closure-dicontainer) [![devDependency Status](https://david-dm.org/steida/grunt-closure-dicontainer/dev-status.png)](https://david-dm.org/steida/grunt-closure-dicontainer#info=devDependencies)

> DI Container for Google Closure.

- concise api
- automatic registration
- resolving based on types
- run-time configuration
- advanced mode compilation friendly

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
        // Name for generated DI container class.
        // goog.require('app.DiContainer');
        name: 'app.DiContainer',

        // What should be resolved.
        // new app.DiContainer().resolveApp()
        resolve: ['App'],

        // Prefix for deps.js.
        prefix: '../../../../'
      },
      files: {
        'client/app/build/dicontainer.js': 'client/deps.js'
      }
    }
  }
})
```

### Options

#### options.name
Type: `String`
Default value: `'app.DiContainer'`

Generated DI container name.

#### options.resolve
Type: `Array.<string>`
Default value: `['App']`

Array of types to be resolved.

#### options.prefix
Type: `String`
Default value: `'../../../../'`

Prefix for `deps.js` processing.

### Usage Example

How to use DI container in you app:

```js
goog.provide('app.main');

goog.require('app.DiContainer');

/**
 * @param {Object} data Server side data.
 */
app.main = function(data) {
  var container = new app.DiContainer();
  // TODO: Add configuration for custom resolving.
  container.resolveApp();
};

goog.exportSymbol('app.main', app.main);
```

Available in [Este](http://github.com/steida/este) soon. Stay tuned.

## Good Articles About DI
  - [kozmic.net/2012/10/23/ioc-container-solves-a-problem-you-might-not-have-but-its-a-nice-problem-to-have](http://kozmic.net/2012/10/23/ioc-container-solves-a-problem-you-might-not-have-but-its-a-nice-problem-to-have)
  - [ayende.com/blog/2887/dependency-injection-doesnt-cut-it-anymore](http://ayende.com/blog/2887/dependency-injection-doesnt-cut-it-anymore)
  - [ayende.com/blog/4372/rejecting-dependency-injection-inversion](http://ayende.com/blog/4372/rejecting-dependency-injection-inversion)
  - [Dependency Injection in .NET](http://www.manning.com/seemann)

## Release History
_(Nothing yet)_
