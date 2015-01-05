angular.module('app').controller 'BrushingAreabrushCtrl', ($log, $scope, $state, $templateCache) ->

  menu = $state.current.data.menuItem
  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}.html"
  $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"

  template = $templateCache.get($scope.chartUrl).substr(1)

  $scope.chartCode = template

  $scope.options = {values:[], domain:[]}

  shapes = ['a', 'b', 'c', 'd', 'e', 'f']
  random = d3.random.normal()
  randomData= (groups, points) ->
    data = []
    for j in [0..points - 1]
      data.push({
        x: random()
        , y: random()
        , group: Math.floor(Math.random() * 10)
        , size: Math.random()   #Configure the size of each scatter point
        , shape: shapes[Math.floor(Math.random() * shapes.length )]   #Configure the shape of each scatter point.
      })
    return data

  $scope.range = [20,400]

  $scope.chartData = randomData(5,50)
  $scope.data = JSON.stringify($scope.chartData,null,3)

  $scope.domainChange = (domain) ->
    $scope.eventData = domain