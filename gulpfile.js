var gulp = require('gulp');
var clean = require('gulp-clean');
var rename = require('gulp-rename');
var elm = require('gulp-elm');

//gulp css
var sourcemaps = require('gulp-sourcemaps')
var sass = require('gulp-sass');
var concat = require('gulp-concat');
var postcss = require('gulp-postcss');

var htmlmin = require('gulp-htmlmin');
//plugins
var autoprefixer = require('autoprefixer');
var csswring = require('csswring')
//browsersync
var browserSync = require('browser-sync');

gulp.task('serve', function() {
    browserSync.init({
      server: {
        baseDir: 'build',
        directory: false
      },
      open: 'local',
      ghostMode: false
    });

    gulp.watch('./src/css/**/*.scss', ['sass', 'postcss']);
    gulp.watch('./src/elm/**/*.elm', ['elm']);
    gulp.watch('./src/img/*.*', ['img']);
    gulp.watch('./src/*.html', ['html'])
});

// compile Elm
gulp.task('elm-init', elm.init);
gulp.task('elm', ['elm-init'], function(){
  gulp.src('src/elm/**/*.elm')
    .pipe(elm())
    .pipe(rename('app.js'))
    .pipe(gulp.dest('./build/js/'))
    .pipe(browserSync.stream());
});

//compile sass
gulp.task('sass', function () {
  gulp.src('src/scss/main.scss')
    .pipe(sourcemaps.init())
      .pipe(sass().on('error', sass.logError))
    .pipe(sourcemaps.write('./maps'))
    .pipe(gulp.dest('./build/css/'))
});

//post-process css (minifying and autoprefixing)
gulp.task('postcss', ['sass'], function(){
  return gulp.src('./build/css/main.css')
      .pipe(sourcemaps.init())
        .pipe(postcss(
          [autoprefixer({browsers: ['last 3 versions']}), csswring()]
          ))
      .pipe(gulp.dest('./build/css/'))
      .pipe(sourcemaps.write('./maps'))
      .pipe(browserSync.stream());

});

//copy over the index file
gulp.task('html', function() {
  gulp.src('src/index.html')
    .pipe(htmlmin({
      collapseWhitespace: true,
      removeComments: true,
      minifyJS: true,
    }))
    .pipe(gulp.dest('./build/'))

    .pipe(browserSync.stream());
});

//copy over any images
gulp.task('img', function() {
  gulp.src('src/img/*.*')
    .pipe(gulp.dest('./build/img/'))
    .pipe(browserSync.stream());
});

//copy over any root directory files
gulp.task('root', function() {
  gulp.src('src/root/**/*.*')
    .pipe(gulp.dest('./build/'))
    .pipe(browserSync.stream());
});

gulp.task('default', ['sass','postcss','elm','root','html','img','serve']);
