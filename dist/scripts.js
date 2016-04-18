'use strict';

var browserSync = require('browser-sync');

var $    = require('gulp-load-plugins')();
var _    = require('lodash');
var cjsx = require('gulp-cjsx');


function buildScripts (params) {
  var params        = params         || {};
  var options       = params.buildOptions || {};
  var gulp          = require(options.modulesData['gulp'].uses);
  var dest          = params.dest    || options.tmp + '/serve/app';
  var src           = params.src     || [options.src + '/app/**/*.coffee', options.src + '/app/**/*.js'];

  var hasJsLint     = options.modulesData['scripts'].js.lint.active;
  var hasCoffeeLint = options.modulesData['scripts'].coffee.lint.active;

  var hasSourceMaps = options.modulesData['scripts'].coffee.sourcemaps.active;

  var coffeeFilter  = $.filter('**/*.coffee');
  var jsFilter      = $.filter('**/*.js');

  return gulp.src(src)
    .pipe(jsFilter)
    .pipe($.if(hasJsLint, $.jshint()))
    .pipe($.if(hasJsLint, $.jshint.reporter('jshint-stylish')))
    .pipe(jsFilter.restore())
    .pipe(coffeeFilter)
    .pipe($.if(hasSourceMaps, $.sourcemaps.init()))
    .pipe($.if(hasCoffeeLint, $.coffeelint()))
    .pipe($.if(hasCoffeeLint, $.coffeelint.reporter()))
    .pipe($.coffee()).on('error', options.errorHandler('CoffeeScript'))
    .pipe($.if(hasSourceMaps, $.sourcemaps.write()))
    .pipe(coffeeFilter.restore())
    .pipe(gulp.dest(dest))
    .pipe(browserSync.stream({ match: '**/*.js' }))
    .pipe($.size());

}

function buildCJSX (params) {
  var params  = params              || {};
  var options = params.buildOptions || {};
  var gulp    = require(options.modulesData['gulp'].uses);
  var dest    = params.dest    || options.tmp + '/serve/app';
  var src     = params.src     || options.src + '/app/**/*.cjsx';

  return gulp.src(src)
    .pipe(cjsx({bare: true}).on('error', options.errorHandler('CoffeeScriptX')))
    .pipe(gulp.dest(dest))
    .pipe(browserSync.stream({ match: '**/*.js' }))
    .pipe($.size());
}


var Scripts = function(buildOptions) {

  var gulp    = require(buildOptions.modulesData['gulp'].uses);

  gulp.task('scripts', function(){
    return buildScripts({buildOptions: buildOptions});
  });

  gulp.task('cjsx', function() {
    return buildCJSX({buildOptions: buildOptions})
  });

  var exports = {
    buildScripts: buildScripts,
    buildCJSX   : buildCJSX
  };

  return exports;
};

module.exports = Scripts;
