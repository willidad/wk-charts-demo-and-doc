angular.module('app').controller 'LinechartsHorizontalCtrl', ($scope, $log, $state, $templateCache) ->

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
    $scope.data.filtered = $scope.data.chartData.slice(50)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)

  $scope.right = () ->
    $scope.data.filtered = $scope.data.chartData.slice(0, $scope.data.chartData.length - 50)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)

  $scope.center = () ->
    $scope.data.filtered = $scope.data.chartData.slice(100, 150)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)

  $scope.reset = () ->
    $scope.data.filtered = $scope.data.chartData
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)
    shift = 0

  shift = 0

  $scope.shiftRight = () ->
    if shift < 200
      shift += 5
    $scope.data.filtered = $scope.data.chartData.slice(100 + shift, 110 + shift)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)

  $scope.shiftLeft = () ->
    if shift > -70
      shift -= 5
    $scope.data.filtered = $scope.data.chartData.slice(100 + shift, 110 + shift)
    $scope.jsonData = JSON.stringify($scope.data.filtered, null, 3)