angular.module('app').controller 'ChartCtrl', ($log, $scope, $templateCache, $state) ->

  menu = $state.current.data.menuItem
  $scope.options = {
    areaStyle:'zero'
    scaleType:''
    domainRange:''
    exponent:1
    domain:[0,100]
  }
  $scope.chartUrl = "app/pages/#{menu.url}/charts#{$state.current.url}.jade"
  $scope.optionsUrl = "app/pages/#{menu.url}/options#{$state.current.url}.jade"


  d3.csv("/app/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.chartData = rows
    $scope.data = JSON.stringify(rows, null, 3)
    $scope.$apply()
  )

  template = $templateCache.get($scope.chartUrl).substr(1)

  $scope.chartCode = template



