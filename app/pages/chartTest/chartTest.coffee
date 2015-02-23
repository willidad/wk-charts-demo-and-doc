angular.module('app').controller 'ChartTestCtrl', ($log, $scope, $compile, $rootScope, $http, $modal, $cookies, wkChartScales, $sanitize) ->

  currentFileIdx = 0

  openFile = (idx) ->
    $scope.openChart($scope.fileList[idx])

  # read file list
  getFileList = () ->
    $log.log 'loading file list'
    $http.get('/list').success((data, status) ->
      if status is 200
        $scope.fileList = data
        currentFileIdx = 0
        openFile(currentFileIdx)
      else
        $scope.fileList = []
    ).error((data, status) ->
      $log.error data,status
    )


  # compile and append the chart

  emptyChart = $scope.chart = {
    code: ''
    data: {}
    scopeVars: {}
  }

  currentChart = emptyChart

  $scope.compile = (chart) ->
    # remove current chart markup
    $scope.chart = emptyChart # ensure data gets cleaned
    chartElem = angular.element(document.querySelector('.compiled-chart'))
    chartElem.children().remove()
    code = chart.code
    $log.log 'compile-scope', $scope.$id
    compiledChart = $compile(code)($scope)
    $scope.chart = chart
    $scope.filtered = chart.data
    chartElem.append(compiledChart)

    return null # do not return a dom node from event handler! Will get Angular exception otherwise



  $scope.openChart = (name) ->
    $log.log 'loading chart:', name
    $http.get('/chart/' + name).success((data,status) ->
      if status is 200
        currentChart = data
        $scope.compile(data)
        $scope.chartName = name
        $scope.chartIdx = currentFileIdx
        $cookies.lastLoaded = name
      else
        $log.error data,status
        $scope.chart = {code:'', data: {}, scopeVars: {}}
    ).error((data, status) ->
      $log.error data,status
    )


  # init

  getFileList()

  #if $cookies.lastLoaded
  #  $scope.openChart($cookies.lastLoaded)

  $scope.scaleMapFn = (value) ->
    $log.log 'scaleMapFn called. value:', value
    return 'red'

  $scope.next = ()->
    currentFileIdx++
    if currentFileIdx < $scope.fileList.length
      openFile(currentFileIdx)
    else
      currentFileIdx--

  $scope.previous = () ->
    currentFileIdx--
    if currentFileIdx >= 0
      openFile(currentFileIdx)
    else
      currentFileIdx++