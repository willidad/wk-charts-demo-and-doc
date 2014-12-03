angular.module('app').controller 'LinechartsVerticalCtrl', ($scope, $log, $state, $templateCache) ->

  menu = $state.current.data.menuItem
  $scope.options = {markers:false}


  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}.html"
  options = $state.current.data.tab.options
  if options
    $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"
  $log.log $scope.chartUrl, $scope.optionsUrl


  d3.csv("data/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.data = {chartData: rows, filtered:rows}
    $scope.chartData = rows
    $scope.jsonData = JSON.stringify(rows, null, 3)
    $scope.$apply()
  )

  template = $templateCache.get($scope.chartUrl)?.substr(1)

  $scope.chartCode = template

  $scope.left = () ->
    $scope.data.filtered = $scope.data.chartData.slice(20)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)

  $scope.right = () ->
    $scope.data.filtered = $scope.data.chartData.slice(0, $scope.data.chartData.length - 20)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)

  $scope.center = () ->
    $scope.data.filtered = $scope.data.chartData.slice(20, $scope.data.chartData.length - 40)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)

  $scope.reset = () ->
    $scope.data.filtered = $scope.data.chartData
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)
    shift = 0

  $scope.cut = () ->
    left = $scope.data.chartData.map((d) -> d)
    left.splice(30,20)
    $scope.data.filtered = left

