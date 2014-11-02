exports.config =
  conventions:
    ignored: /jquery.js|bootstrap.js/
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  files:
    javascripts:
      joinTo:
        'js/vendor.js': /^bower_components/
        'js/app.js': /^app/
    stylesheets:
      joinTo: 'css/app.css'
    templates:
      joinTo:
        'js/dontUseMe' : /^app/ # dirty hack for Jade compiling.

  plugins:
    jade:
      pretty: yes # Adds pretty-indentation whitespaces to output (false by default)
    jade_angular:
      locals: {}
    marked:
      sanitize: true

  minify: true