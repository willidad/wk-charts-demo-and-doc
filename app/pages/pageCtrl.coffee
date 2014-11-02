angular.module('app').controller 'PageCtrl', ($log, $scope, $state, menu) ->

  page = $state.current.data
  if page
    $scope.pageUrl = page.menuItem.url
    $scope.tabs = page.menuItem.tabs
    $scope.tabIsActive = []
    $scope.tabIsActive[$state.current.data.chartIdx] = true

  $scope.tabActive = []

