// file name and directory definitions

var buildDir = './build';

var gulp            = require('gulp');
var notify          = require('gulp-notify');
var gutil           = require('gulp-util');
var connect         = require('gulp-connect');
var coffee          = require('gulp-coffee');
var sourcemaps      = require('gulp-sourcemaps');
var concat          = require('gulp-concat');
var tplCache        = require('gulp-angular-templatecache');
var jade            = require('gulp-jade');
var less            = require('gulp-less');
var markdown        = require('gulp-markdown');
var es              = require('event-stream');
var highlight       = require('highlight');
var mainBowerFiles  = require('main-bower-files');

console.log(mainBowerFiles({filter:/\.js$/}));

 gulp.task('appJS', function() {
  // concatenate compiled .coffee files and js files
  // into build/app.js
    var js = gulp.src(['!./app/**/*_test.js','./app/**/*.js'])
        .pipe(sourcemaps.init());

    var csJs = gulp.src(['!./app/**/*_test.coffee','./app/**/*.coffee'])
        .pipe(sourcemaps.init())
        .pipe(coffee({bare:true, doctype:'html'}).on('error', gutil.log));

    es.merge(js,csJs)
    .pipe(concat('app.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(buildDir + '/js'))
});

 gulp.task('testJS', function() {
    // Compile JS test files. Not compiled.
    var js = gulp.src(['./app/**/*_test.js'])
        .pipe(sourcemaps.init());

    var csJs = gulp.src(['./app/**/*_test.coffee'])
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}).on('error', gutil.log));

    es.merge(js, csJs)
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(buildDir + '/js'))
});

 gulp.task('templates', function() {
  // combine compiled Jade and html template files into 
  // build/template.js
    var jadeTempl = gulp.src(['!./app/index.jade', './app/**/*.jade'])
        .pipe(jade({pretty:true, doctype:'html'}).on('error', notify));

    var htmlTempl = gulp.src(['!./app.index.html', './app/**/*.html']);

    var markdownTempl = gulp.src(['./app/**/*.md'])
        .pipe(markdown());

    es.merge(jadeTempl, htmlTempl, markdownTempl)
      .pipe(tplCache('templates.js',{standalone:true}))
      .pipe(gulp.dest(buildDir + '/js'))
});

 gulp.task('chartData', function() {
    gulp.src(['./app/**/*.csv'])
    .pipe(gulp.dest('./build/data'))
});


 gulp.task('appCSS', function() {
  // concatenate compiled Less and CSS
  // into build/app.css
    var cssSrc = gulp.src(['./app/**/*.css'])
        .pipe(sourcemaps.init());
    var lessSrc = gulp.src(['./app/**/*.less'])
        .pipe(sourcemaps.init())
        .pipe(less({paths: ['./bower_components/bootstrap/less']}).on('error', notify));

    es.merge(cssSrc, lessSrc)
    .pipe(concat('app.css'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(buildDir + '/css'))
});

 gulp.task('libJS', function() {
  gulp.src(mainBowerFiles({filter:/\.js$/}),{base:'bower_components'})
      .pipe(sourcemaps.init())
      .pipe(concat('vendor.js'))
      .pipe(sourcemaps.write())
      .pipe(gulp.dest(buildDir + '/js'))
});

 gulp.task('libCSS',
  function() {
  // concatenate vendor css into build/lib.css
  gulp.src(mainBowerFiles({filter:/\.css$/}))
      .pipe(sourcemaps.init())
      .pipe(concat('lib.css'))
      .pipe(sourcemaps.write())
      .pipe(gulp.dest(buildDir + '/css'));
});

 gulp.task('index', function() {
    var indexHtml = gulp.src(['./app/index.html']);

    var indexJade = gulp.src(['./app/index.jade'])
        .pipe(jade({doctype:'html'}).on('error', gutil.log));

    es.merge(indexHtml, indexJade)
    .pipe(gulp.dest(buildDir));
});

 gulp.task('watch',function() {

  // reload connect server on built file change
     gulp.watch([
      buildDir + '/**/*.html',
      buildDir + '/**/*.js',
      buildDir + '/**/*.css',
      buildDir + '/**/*.csv'
  ], function(event) {
       gulp.src(event.path)
          .pipe(connect.reload());
  });

  // watch files to build
     gulp.watch(['./app/**/*.coffee', '!./app/**/*_test.coffee', './app/**/*.js', '!./app/**/*_test.js'], ['appJS']);
     gulp.watch(['./app/**/*_test.coffee', './app/**/*_test.js'], ['testJS']);
     gulp.watch(['!./app/index.jade', '!./app/index.html', './app/**/*.jade', './app/**/*.html', './app/**/*.md'], ['templates']);
     gulp.watch(['./app/**/*.less', './app/**/*.css'], ['appCSS']);
     gulp.watch(['./app/index.jade', './app/index.html'], ['index']);
});

 gulp.task('connect', function() {
    connect.server({
        root: 'build',
        port: 3333,
        livereload: true
    })
});

 gulp.task('default', ['connect', 'appJS', 'testJS', 'templates', 'chartData', 'appCSS', 'index', 'libJS', 'libCSS', 'watch']);
