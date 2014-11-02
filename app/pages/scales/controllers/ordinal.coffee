angular.module('app').controller 'ScalesOrdinalCtrl', ($log, $scope, $templateCache, $state, $filter) ->

  menu = $state.current.data.menuItem
  $scope.options = {
    areaStyle:'zero'
    scaleType:''
    domainRange:''
    exponent:1
    domain:[0,100]
    dateFormat:'%Y%m%d'
    colorScale:'category20'
    colorRange:'#1f77b4,#ff7f0e,blue,yellow,orange,brown, red'
  }
  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}.html"
  $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"


  d3.csv("/app/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.chartData = rows
    $scope.data = JSON.stringify(rows, null, 3)
    $scope.$apply()
  )

  template = $templateCache.get($scope.chartUrl).substr(1)

  $scope.chartCode = template

  $scope.shuffleData = () ->
    $scope.chartData = d3.shuffle($scope.chartData)
    $scope.data = JSON.stringify($scope.chartData, null, 3)