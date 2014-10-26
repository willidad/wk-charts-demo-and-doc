angular.module('app').controller 'PageCtrl', ($log, $scope, $state, menu) ->

  page = $state.current.data
  if page
    $scope.pageUrl = page.menuItem.url
    $scope.tabs = page.menuItem.tabs

  $scope.tabIsActive = (idx) ->
    idx is $state.current.data.chartIdx

