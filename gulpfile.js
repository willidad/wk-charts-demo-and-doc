// file name and directory definitions

var buildDir = './build';

var gulp            = require('gulp');
var gutil           = require('gulp-util');
var connect         = require('gulp-connect');
var gulpif          = require('gulp-if');
var coffee          = require('gulp-coffee');
var sourcemaps      = require('gulp-sourcemaps');
var concat          = require('gulp-concat');
var tplCache        = require('gulp-angular-templatecache');
var jade            = require('gulp-jade');
var less            = require('gulp-less');
var markdown        = require('gulp-markdown');
var es              = require('event-stream');
var mainBowerFiles  = require('main-bower-files');

console.log(mainBowerFiles({filter:/\.css$/}));

gulp.task('appJS', function() {
  // concatenate compiled .coffee files and js files
  // into build/app.js
    var js = gulp.src(['!./app/**/*_test.js','./app/**/*.js'])
        .pipe(sourcemaps.init());
    var csJs = gulp.src(['!./app/**/*_test.coffee','./app/**/*.coffee'])
        .pipe(sourcemaps.init())
        .pipe(coffee({bare:true}).on('error', gutil.log));
    es.merge(js,csJs)
    .pipe(concat('app.js'))
    .pipe(sourcemaps.write('/maps'))
    .pipe(gulp.dest(buildDir))
});

gulp.task('testJS', function() {
  // Compile JS test files. Not compiled.
  gulp.src([
      './app/**/*_test.js',
      './app/**/*_test.coffee'
    ])
    .pipe(
      gulpif(/[.]coffee$/,
        coffee({bare: true})
        .on('error', gutil.log)
      )
    )
    .pipe(gulp.dest(buildDir))
});

gulp.task('templates', function() {
  // combine compiled Jade and html template files into 
  // build/template.js
    var jadeTempl = gulp.src(['!./app/index.jade', './app/**/*.jade'])
        .pipe(jade({pretty:true}).on('error', gutil.log));

    var htmlTempl = gulp.src(['!./app.index.html', './app/**/*.html']);

    var markdownTempl = gulp.src(['./app/**/*.md'])
        .pipe(markdown());

    es.merge(jadeTempl, htmlTempl, markdownTempl) //.pipe(gulpif(/[.]jade$/, jade({pretty:true}).on('error', gutil.log))
      .pipe(tplCache('templates.js',{standalone:true}))
      .pipe(gulp.dest(buildDir))
});

gulp.task('chartData', function() {
    gulp.src(['./app/**/*.csv'])
    .pipe(gulp.dest('./build/data'))
});


gulp.task('appCSS', function() {
  // concatenate compiled Less and CSS
  // into build/app.css
  gulp
    .src([
      './app/**/*.less',
      './app/**/*.css'
    ])
    .pipe(
      gulpif(/[.]less$/,
        less({
          paths: [
            './bower_components/bootstrap/less'
          ]
        })
        .on('error', gutil.log))
    )
    .pipe(
      concat('app.css')
    )
    .pipe(
      gulp.dest(buildDir)
    )
});

gulp.task('libJS', function() {
  gulp.src(mainBowerFiles({filter:/\.js$/}),{base:'bower_components'})
      .pipe(sourcemaps.init())
      .pipe(concat('vendor.js'))
      .pipe(sourcemaps.write('/maps'))
      .pipe(gulp.dest(buildDir))
});
gulp.task('libCSS',
  function() {
  // concatenate vendor css into build/lib.css
  gulp.src(mainBowerFiles({filter:/\.css$/}))
      .pipe(sourcemaps.init())
      .pipe(concat('lib.css'))
      .pipe(sourcemaps.write('/maps'))
      .pipe(gulp.dest(buildDir));
});

gulp.task('index', function() {
  gulp.src(['./app/index.jade', './app/index.html'])
    .pipe(gulpif(/[.]jade$/, jade().on('error', gutil.log)))
    .pipe(gulp.dest(buildDir));
});

gulp.task('watch',function() {

  // reload connect server on built file change
  gulp.watch([
      'build/**/*.html',        
      'build/**/*.js',
      'build/**/*.css',
      'build/**/*.csv'
  ], function(event) {
      return gulp.src(event.path)
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
