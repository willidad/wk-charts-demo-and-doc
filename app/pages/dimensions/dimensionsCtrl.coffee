angular.module('app').controller 'DimensionsCtrl', ($scope, $log, $state, $templateCache) ->

  menu = $state.current.data.menuItem

  options = $state.current.data.tab.options
  if options
    $scope.optionsUrl = "./lib/docs/dimension#{$state.current.url}.html"
  $log.log $scope.optionsUrl