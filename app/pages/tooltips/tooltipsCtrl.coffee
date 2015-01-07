angular.module('app').controller 'TooltipsCtrl', ($scope, $log, $state, $templateCache, $templateRequest) ->

  menu = $state.current.data.menuItem

  options = $state.current.data.tab.url
  if options is 'tooltips'
    optionsUrl = "./lib/docs/behavior/tooltips.html"
  if options is 'custom'
    optionsUrl = "../lib/docs/guide/tooltips.html"

  $templateRequest(optionsUrl).then((result) ->
     $scope.optionsText = result
    )
