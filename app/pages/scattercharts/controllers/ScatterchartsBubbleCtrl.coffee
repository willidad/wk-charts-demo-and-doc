angular.module('app').controller 'ScatterchartsBubbleCtrl', ($log, $scope, $templateCache, $state) ->

  menu = $state.current.data.menuItem
  $scope.options = {year:2013, range:[10,40]}


  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}.html"
  options = $state.current.data.tab.options
  if options
    $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"
  $log.log $scope.chartUrl, $scope.optionsUrl


  d3.csv("data/pages/#{menu.url}/data#{$state.current.url}.csv", (rows) ->
    $scope.chartData = rows
    $scope.data = JSON.stringify(rows, null, 3)
    #$scope.filteredData = _.where($scope.chartData, {Year:'2013'})
    $scope.$apply()
  )

  template = $templateCache.get($scope.chartUrl)?.substr(1)

  $scope.chartCode = template

  $scope.$watch 'options.year', (val) ->
    #$scope.filteredData = _.where($scope.chartData, {Year:val.toString()})
    $log.log $scope.filteredData, val