// file name and directory definitions

var buildDir = './build';

var gulp            = require('gulp');
var plumber         = require('gulp-plumber');
var notify          = require('gulp-notify');
var gutil           = require('gulp-util');
var coffee          = require('gulp-coffee');
var sourcemaps      = require('gulp-sourcemaps');
var concat          = require('gulp-concat');
var tplCache        = require('gulp-angular-templatecache');
var jade            = require('gulp-jade');
var less            = require('gulp-less');
var markdown        = require('gulp-markdown');
var bump            = require('gulp-bump');
var es              = require('event-stream');
var annotate        = require('gulp-ng-annotate');
var mainBowerFiles  = require('main-bower-files');
var bower           = require('gulp-bower');
var lifereload      = require('gulp-livereload');
var del             = require('del');
var runSequence     = require('run-sequence');

gulp.task('bower-update', function() {
    return bower({ cmd: 'update'});
});

gulp.task('bower-install', function() {
    return bower();
});

gulp.task('buildLib', function() {
    runSequence('bower-update', ['libJS', 'libCSS'])
});

gulp.task('cleanBuildDir', function(done) {
    return del([buildDir], done)
});

gulp.task('appJS', function() {
    // concatenate compiled .coffee files and js files
    // into build/app.js
    var js = gulp.src(['!./app/**/*_test.js','./app/**/*.js'],{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(sourcemaps.init());

    var csJs = gulp.src(['!./app/**/*_test.coffee','./app/**/*.coffee'],{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(sourcemaps.init())
        .pipe(coffee({bare:true, doctype:'html'}));

    return es.merge(js,csJs)
        .pipe(concat('app.js'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(buildDir + '/js'))
        .pipe(lifereload())
});

gulp.task('wkChartsCopyJs', function() {
    return gulp.src(['./../wk-charts/dist/lib/*.js', './../wk-charts/dist/lib/**/*.map'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(gulp.dest(buildDir + '/lib'))
        .pipe(lifereload())
});

gulp.task('wkChartsCopyCss', function() {
    return gulp.src(['./../wk-charts/dist/lib/*.css'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(gulp.dest(buildDir + '/lib'))
        .pipe(lifereload())
});

gulp.task('wkChartsCopyDocs', function() {
    return gulp.src(['./../wk-charts/dist/docs/**/*.*'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(gulp.dest(buildDir + '/lib/docs'))
        .pipe(lifereload())
});

gulp.task('wkChartsBumpVersion', function() {
    return gulp.src('./../wk-charts/bower.json')
        .pipe(bump())
        .pipe(gulp.dest('./../wk-charts/'));
        //.pipe(gulp.dest('./../wk-charts/dist'))
});

gulp.task('testJS', function() {
    // Compile JS test files. Not compiled.
    var js = gulp.src(['./app/**/*_test.js'],{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(sourcemaps.init());

    var csJs = gulp.src(['./app/**/*_test.coffee'],{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}).on('error', gutil.log));

    return es.merge(js, csJs)
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(buildDir + '/js'))
});

gulp.task('templates', function() {
    // combine compiled Jade and html template files into
    // build/template.js
    // jade templates
    var jadeTempl = gulp.src(['!./app/index.jade', './app/**/*.jade'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(jade({pretty:true, doctype:'html'}));
    // html templates
    var htmlTempl = gulp.src(['!./app.index.html', './app/**/*.html'])
        .pipe(plumber({errorHandler: errorAlert}));
    // markdown templates
    var markdownTempl = gulp.src(['./app/**/*.md'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(markdown());

    return es.merge(jadeTempl, htmlTempl, markdownTempl)
        .pipe(tplCache({standalone:true}))
        .pipe(gulp.dest(buildDir + '/js'))
        .pipe(lifereload())
});

gulp.task('chartData', function() {
    return gulp.src(['./app/pages/**/data/*'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(gulp.dest('./build/data/pages'))
});

gulp.task('appCSS', function() {
    // concatenate compiled Less and CSS
    // into build/app.css
    var cssSrc = gulp.src(['./app/**/*.css'],{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(sourcemaps.init());
    var lessSrc = gulp.src(['./app/**/*.less'],{base:'./'})
        .pipe(sourcemaps.init())
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(less({paths: ['./bower_components/bootstrap1/less']}).on('error', notify));

    return es.merge(cssSrc, lessSrc)
        .pipe(concat('app.css'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(buildDir + '/css'))
        .pipe(lifereload())
});

gulp.task('libJS', function() {
    return gulp.src(mainBowerFiles({filter:/\.js$/}),{base:'./'})
      .pipe(plumber({errorHandler: errorAlert}))
      .pipe(sourcemaps.init())
      .pipe(concat('vendor.js'))
      .pipe(sourcemaps.write())
      .pipe(gulp.dest(buildDir + '/js'))
});

gulp.task('libCSS', function() {
    // concatenate vendor css into build/lib.css
    return gulp.src(mainBowerFiles({filter:/\.css$/}),{base:'./'})
        .pipe(sourcemaps.init())
        .pipe(concat('lib.css'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(buildDir + '/css'));
});

gulp.task('index', function() {
    var indexHtml = gulp.src(['./app/index.html']);

    var indexJade = gulp.src(['./app/index.jade'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(jade({doctype:'html'}));

    return es.merge(indexHtml, indexJade)
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(gulp.dest(buildDir))
        .pipe(lifereload())
});

gulp.task('watch',function() {
    // watch files to build
    lifereload.listen({basePath:buildDir});
    gulp.watch(['./app/**/*.coffee', '!./app/**/*_test.coffee', './app/**/*.js', '!./app/**/*_test.js'], ['appJS']); // application source
    gulp.watch(['./app/**/*_test.coffee', './app/**/*_test.js'], ['testJS']); // application tests
    gulp.watch(['!./app/index.jade', '!./app/index.html', './app/**/*.jade', './app/**/*.html', './app/**/*.md'], ['templates']); //application templates
    gulp.watch(['./app/**/*.less', './app/**/*.css'], ['appCSS']); // application css
    gulp.watch(['./app/index.jade', './app/index.html'], ['index']); // index file
    gulp.watch(['./app/pages/**/data/*.csv'], ['chartData']); // examples data files
    gulp.watch(['./../wk-charts/dist/lib/*.js'], ['wkChartsCopyJs']); // copy chart library on change
    gulp.watch(['./../wk-charts/dist/lib/*.css'], ['wkChartsCopyCss']); // copy chart css on change
    gulp.watch(['./../wk-charts/dist/docs/**/*.html'], ['wkChartsCopyDocs']); // copy chart docs on change
});

gulp.task('default', function() {
    runSequence('cleanBuildDir', ['buildLib', 'appJS', 'appCSS', 'templates', 'wkChartsCopyJs', 'wkChartsCopyCss', 'wkChartsCopyDocs', 'index', 'chartData'])
});

function errorAlert(error){
    notify.onError({title: "Gulp Error", message: "<%= error.message %>", sound: "Sosumi"})(error);
    console.log(error.toString());
    this.emit("end");
}
