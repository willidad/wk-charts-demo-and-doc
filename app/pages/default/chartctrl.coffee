angular.module('app').controller 'ChartCtrl', ($log, $scope, $templateCache, $state) ->

  menu = $state.current.data.menuItem
  $scope.chartUrl = "app/pages/#{menu.url}/charts#{$state.current.url}.jade"
  $log.info $scope.chartUrl


  d3.csv("/app/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.chartData = rows
    $scope.data = JSON.stringify(rows, null, 3)
    $scope.$apply()
  )

  template = $templateCache.get($scope.chartUrl)

  $scope.chartCode = template



