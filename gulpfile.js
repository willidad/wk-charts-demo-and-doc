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
var webserver       = require('gulp-webserver');


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
});

gulp.task('wkChartsJs', function() {
    // compile an concatenate wk-charts library:
    //   Coffeescript
    var csJs = gulp.src('./../wk-charts/app/**/*.coffee',{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(sourcemaps.init())
        .pipe(coffee({bare:true, doctype:'html'}));

    // Jade templates
    var templ = gulp.src('./../wk-charts/app/**/*.jade')
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(jade({pretty:true, doctype:'html'}))
        .pipe(tplCache({module:'wk.chart'}));

    // Javascript components
    var js = gulp.src('./../wk-charts/app/**/*.js',{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(sourcemaps.init());

    return es.merge(csJs, js, templ)
        .pipe(concat('wk-charts.js'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest(buildDir + '/lib'))
});

gulp.task('wkChartsCss', function() {
    // watch wk-charts project for changes
    return gulp.src('./../wk-charts/app/**/*.css',{base:'./'})
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(concat('wk-charts.css'))
        .pipe(gulp.dest(buildDir + '/lib'))
});

gulp.task('wkChartsCopy',['wkChartsJs', 'wkChartsCss', 'wkChartsBumpVersion'], function() {
    return gulp.src([buildDir + '/lib/**/*.*'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(gulp.dest('./../wk-charts/dist/lib'))
});

gulp.task('wkChartsBumpVersion', function() {
    return gulp.src('./../wk-charts/bower.json')
        .pipe(bump())
        .pipe(gulp.dest('./../wk-charts/'))
        .pipe(gulp.dest('./../wk-charts/dist'))
})

gulp.task('watchWkChartsJs', function() {
    gulp.watch(['./../wk-charts/app/**/*.coffee', './../wk-charts/app/**/*.js'], ['wkChartsJs', 'wkChartsCopy'])
});
gulp.task('watchWkChartsCss', function() {
    gulp.watch(['./../wk-charts/app/**/*.css'], ['wkChartsCss'])
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
});

gulp.task('chartData', function() {
    return gulp.src(['./app/**/*.csv'])
        .pipe(plumber({errorHandler: errorAlert}))
        .pipe(gulp.dest('./build/data'))
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
        .pipe(gulp.dest(buildDir));
});

gulp.task('watch',function() {
    // watch files to build
    gulp.watch(['./app/**/*.coffee', '!./app/**/*_test.coffee', './app/**/*.js', '!./app/**/*_test.js'], ['appJS']);
    gulp.watch(['./app/**/*_test.coffee', './app/**/*_test.js'], ['testJS']);
    gulp.watch(['!./app/index.jade', '!./app/index.html', './app/**/*.jade', './app/**/*.html', './app/**/*.md'], ['templates']);
    gulp.watch(['./app/**/*.less', './app/**/*.css'], ['appCSS']);
    gulp.watch(['./app/index.jade', './app/index.html'], ['index']);
    gulp.watch(['./app/**/*.csv'], ['chartData']);
    gulp.watch(['./bower_components/**/.*.*'], ['libJS', 'libCss'])
});

gulp.task('webserver', function() {
    gulp.src(buildDir + '/')
        .pipe(webserver({
            host:'0.0.0.0',
            port:3333,
            livereload: true,
            directoryListing: false,
            fallback: 'index.html',
            open: false
        }));
});

gulp.task('default', ['webserver', 'appJS', 'templates', 'chartData', 'appCSS', 'index', 'libJS', 'libCSS', 'wkChartsJs', 'wkChartsCss', 'watchWkChartsJs', 'watchWkChartsCss', 'watch']);

function errorAlert(error){
    notify.onError({title: "Gulp Error", message: "<%= error.message %>", sound: "Sosumi"})(error);
    console.log(error.toString());
    this.emit("end");
}
