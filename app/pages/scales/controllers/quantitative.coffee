angular.module('app').controller 'ScalesQuantitativeCtrl', ($log, $scope, $templateCache, $state) ->

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


  d3.csv("data/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.chartData = rows.map((d) -> {date:d.date,'New York':(d['New York']-32)*5/9, 'San Francisco':(d['San Francisco']-32)*5/9, Austin:(d['Austin']-32)*5/9 })
    $scope.data = JSON.stringify(rows, null, 3)
    $scope.$apply()
  )

  template = $templateCache.get($scope.chartUrl).substr(1)

  $scope.chartCode = template