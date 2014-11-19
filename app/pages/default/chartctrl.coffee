angular.module('app').controller 'ChartCtrl', ($log, $scope, $templateCache, $state) ->

  menu = $state.current.data.menuItem
  $scope.chartData = []

  $scope.options = {
    areaStyle:'zero'
    scaleType:''
    domainRange:''
    exponent:1
    domain:[0,100]
    selection: []
    dateFormat:'%Y%m%d'
    colorScale:'category20'
    colorRange:'#1f77b4,#ff7f0e,blue,yellow,orange,brown, red'
    thresholdRange:'red, yellow,lightblue,green'
    thresholdDomain:'-1,1,4'
    markers:false
    year:2013
    axis:'false'
    rotation: 0
    label: ''
    showLabel: false
    areaProperty: ['Chrome', 'Internet Explorer', 'Firefox', 'Safari', 'Opera']
    padding:[10,0]
    labels:false

  }
  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}.html"
  options = $state.current.data.tab.options
  if options
    $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"
  $log.log $scope.chartUrl, $scope.optionsUrl


  d3.csv("data/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.data = {chartData: rows, filtered:[]}
    $scope.chartData = rows
    $scope.jsonData = JSON.stringify(rows, null, 3)
    $scope.$apply()
  )

  template = $templateCache.get($scope.chartUrl)?.substr(1)

  $scope.chartCode = template



