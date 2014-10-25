angular.module('app').controller 'Page1Chart1Ctrl', ($log, $scope, $templateCache, $state) ->

  pageIdx = $state.current.data.pageIdx
  chartIdx = $state.current.data.chartIdx

  d3.csv("/app/pages/page#{pageIdx}/data/chart#{chartIdx+1}.csv", (rows) ->
    $scope.chartData = rows
    $scope.data = JSON.stringify(rows, null, 3)
    $scope.$apply()
  )

  template = $templateCache.get($state.current.templateUrl)
  lastChart = template.indexOf('<tabset>')

  $scope.chartCode = if lastChart > 0 then template.substr(1,lastChart-1) else template



