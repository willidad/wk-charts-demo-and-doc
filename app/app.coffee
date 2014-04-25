angular.module('app', ['ui.router','ui.bootstrap','app.templates'])
  .config(($stateProvider, $urlRouterProvider) ->
  #$locationProvider.html5Mode(true)

    $urlRouterProvider
      .otherwise "/"

    $stateProvider
      .state 'content',
        views:
          'top':
            templateUrl: 'app/topnav/top.jade'
            controller: 'TopCtrl'
          'left':
            templateUrl: 'app/left/left.jade'
            controller: 'LeftCtrl'
          'content':
            templateUrl: 'app/content/content.jade'
            controller: 'ContentCtrl'
          'right':
            templateUrl: 'app/right/right.jade'
            controller: 'RightCtrl'
          'footer':
            templateUrl: 'app/footer/footer.jade'
            controller: 'FooterCtrl'
        url: '/'
)