angular.module('app').controller 'BrushingMultiCtrl', ($scope, $log, $state, $templateCache) ->

  menu = $state.current.data.menuItem
  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}.html"
  $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"

  template = $templateCache.get($scope.chartUrl).substr(1)

  $scope.chartCode = template

  $scope.options = {}

  dateFormat = d3.time.format("%d.%m.%Y")

  d3.csv("data/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.chartData = rows
    $scope.data = JSON.stringify(rows, null, 3)
    $scope.$apply()
  ).row((d) ->
    return {date:dateFormat.parse(d.hpqdate), hpq:{close:+d.hpqclose, volume:+d.hpqvolume},intc:{close:+d.intcclose, volume:+d.intcvolume}, msft:{close:+d.msftclose,volume:+d.msftvolume}}
  )