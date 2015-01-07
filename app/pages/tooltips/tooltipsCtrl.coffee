angular.module('app').controller 'TooltipsCtrl', ($scope, $log, $state, $templateCache) ->

  menu = $state.current.data.menuItem

  options = $state.current.data.tab.options
  if options
    $scope.optionsUrl = "./lib/docs/behavior/tooltips.html"
  $log.log $scope.optionsUrl