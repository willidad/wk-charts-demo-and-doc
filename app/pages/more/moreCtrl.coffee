angular.module('app').controller 'MoreCtrl', ($log, $scope, $compile, $rootScope, $http, $modal, $cookies, wkChartScales) ->

  bool = ['', 'true', 'false']
  dimensions = ["x", "y", "color", "size", "shape", "range-x", "range-y"]
  scaleTypes = _.keys(d3.scale).concat(['time']).concat(_.keys(wkChartScales))
  layouts = {
    area:[]
    'area-vertical':[]
    'area-stacked':['', 'zero', 'silhouette', 'expand', 'wiggle']
    'area-stacked-vertical':['', 'zero', 'silhouette', 'expand', 'wiggle']
    bar:[]
    'bar-clustered':[]
    'bar-stacked':[]
    bubble:[]
    column:[]
    'column-clustered':[]
    'column-stacked':[]
    gauge:[]
    'geo-map':['projection', 'geo-json']
    histogram:[]
    line:[]
    'line-vertical':[]
    pie:[]
    scatter:[]
    spider:[]
    # --- layout specific attributes
    markers:bool
    labels:bool
    brush:['']
    selected:['']
    'selected-domain':['']
    'selected-values':['']
    'brush-extent':['']
    padding:[]
    'outer-padding':[]

  }

  legendPositions = ['top-right', 'top-left', 'bottom-right', 'bottom-left', '#legend-div-id']

  scaleAttrs =
    attrs:
      axis: ['true', 'false', 'top', 'bottom', 'left', 'right']
      type: scaleTypes
      property: []
      range: []
      domain: []
      'domain-range': ['min', 'max', 'extent', 'total', 'rangeMin', 'rangeMax', 'rangeExtent']
      format: ['']
      exponent: ['']
      'layer-property': ['']
      reset: null
      'tick-format': ['']
      ticks: ['']
      'rotate-tick-labels':[]
      'grid': bool
      label: ['']
      'show-label': bool
      legend: legendPositions
      'values-legend': legendPositions
      'legend-title': ['']
      'lower-property': ['']
      'upper-property': ['']
      brush: ['']
      brushed: ['']


    children:[]


  tags = {
    "!top": ["chart"],
    chart: {
      attrs: {
        data: ["en", "de", "fr", "nl"],
        'deep-watch': bool
        tooltips:  bool
        'animation-duration':['0', '300','600','900', '']
        filter: ['']
        title:['']
        subtitle:['']
        class:['h20', 'h50', 'h80', 'w20', 'w50', 'w80']
        id:null
      },
      children: ["layout"].concat(dimensions)
    },
    layout: {
      attrs: layouts,
      children: dimensions
    },
    x: scaleAttrs
    y: scaleAttrs
    size: scaleAttrs,
    shape: scaleAttrs,
    'range-x': scaleAttrs,
    'range-y': scaleAttrs,
    color: scaleAttrs
  };



  emptyChart = $scope.chart = {
    code: ''
    data: {}
    scopeVars: {}
  }

  completeAfter = (cm, pred) ->
    cur = cm.getCursor()
    if not pred or pred()
      setTimeout(() ->
        if (!cm.state.completionActive)
          cm.showHint({completeSingle: false})
      , 100
      )
    return CodeMirror.Pass

  completeIfAfterLt = (cm) ->
    return completeAfter(cm, () ->
      cur = cm.getCursor()
      return cm.getRange(CodeMirror.Pos(cur.line, cur.ch - 1), cur) == "<")

  completeIfInTag = (cm) ->
    return completeAfter(cm, () ->
      tok = cm.getTokenAt(cm.getCursor())
      if (tok.type is "string" and (not /['"]/.test(tok.string.charAt(tok.string.length - 1)) or tok.string.length == 1))
        return false;
      inner = CodeMirror.innerMode(cm.getMode(), tok.state).state;
      return inner.tagName
    )

  $scope.options = {
    lineNumbers:true
    mode:'text/html'
    extraKeys:  {
      "'<'": completeAfter,
      "'/'": completeIfAfterLt,
      "' '": completeIfInTag,
      "'='": completeIfInTag,
      "Ctrl-Space": "autocomplete"
    }
    hintOptions: {schemaInfo: tags}
  }
  #---------------------------------------------------------------------------------------------------------------------
  # read file list
  getFileList = () ->
    $log.log 'loading file list'
    $http.get('/list').success((data, status) ->
      if status is 200
        $scope.fileList = data
      else
        $scope.fileList = []
    ).error((data, status) ->
      $log.error data,status
    )


  # compile and append the chart

  currentChart = emptyChart

  $scope.compile = (chart) ->
    # remove current chart markup
    $scope.chart = emptyChart # ensure data gets cleaned
    chartElem = angular.element(document.querySelector('.compiled-chart'))
    chartElem.children().remove()
    code = chart.code
    compiledChart = $compile(code)($scope)
    $scope.chart = chart
    chartElem.append(compiledChart)

    $scope.chart = chart
    return null # do not return a dom node from event handler! Will get Angular exception otherwise



  $scope.openChart = (name) ->
    $log.log 'reading', name
    $http.get('/chart/' + name).success((data,status) ->
      if status is 200
        currentChart = data
        $scope.compile(data)
        $scope.chartName = name
        $cookies.lastLoaded = name
      else
        $log.error data,status
        $scope.chart = {code:'', data: {}, scopeVars: {}}
    ).error((data, status) ->
      $log.error data,status
    )

  $scope.saveChart = (name) ->
    $log.log 'saving', name, $scope.chart
    $http.put('/chart/' + name, $scope.chart).success((data,status) ->
      if status isnt 200
        $log.error data,status
    ).error((data, status) ->
      $log.error data,status
    )

  $scope.saveChartAs = (name) ->
    dialog = $modal.open({
        size: 'sm'
        template: '<div class="modal-header"><h4 class="modal-title">Enter File name</h4></div>
                <div class="modal-body"><input type="text" ng-model="fileName" style="width:100%;"></div>
                <div class="modal-footer"><button class="btn btn-primary" ng-click="ok()">OK</button><button class="btn btn-warning" ng-click="cancel()">Cancel</button></div>'
        controller: ($scope, $modalInstance) ->
          $scope.ok = () ->
            $modalInstance.close($scope.fileName)
          $scope.cancel = () ->
            $modalInstance.dismiss('cancel')
      })
    dialog.result.then((value) ->
      $log.log 'New File name', value
      $http.post('/chart/' + value, $scope.chart).success((data,status) ->
        if status isnt 200
          $log.error data,status
        else
          getFileList()
          $scope.chartName = value
      ).error((data, status) ->
        $log.error data,status
      )
    )

  $scope.deleteChart = () ->
    dialog = $modal.open({
      size: 'sm'
      template: '<div class="modal-header"><h4 class="modal-title">Remove File</h4></div>
                <div class="modal-body">Remove {{fileName}} ?</div>
                <div class="modal-footer"><button class="btn btn-primary" ng-click="ok()">OK</button><button class="btn btn-warning" ng-click="cancel()">Cancel</button></div>'
      resolve: {fileName: () ->
        $scope.chartName
      }
      controller: ($scope, $modalInstance, fileName) ->
        $scope.fileName = fileName
        $scope.ok = () ->
          $modalInstance.close($scope.fileName)
        $scope.cancel = () ->
          $modalInstance.dismiss('cancel')
    })
    dialog.result.then((value) ->
      $log.log 'New File name', value
      $http.delete('/chart/' + value).success((data,status) ->
        if status isnt 200
          $log.error data,status
        else
          getFileList()
          $scope.chart = emptyChart
          $scope.chartName = ''
      ).error((data, status) ->
        $log.error data,status
      )
    )

  $scope.addData = () ->
    dialog = $modal.open({
      size: 'lg'
      template: '<div class="modal-header"><h4 class="modal-title">Enter Data as JSON or CSV text</h4></div>
              <div class="modal-body"><textarea ng-model="data" style="width:100%; height:500px;"></textarea></div>
              <div class="modal-footer"><button class="btn btn-primary" ng-click="Json()">Save JSON</button><button class="btn btn-primary" ng-click="csv()">Save CSV</button><button class="btn btn-warning" ng-click="cancel()">Cancel</button></div>'
      controller: ($scope, $modalInstance) ->
        $scope.Json = () ->
          $modalInstance.close(JSON.parse($scope.data))
        $scope.csv = () ->
          $modalInstance.close(d3.csv.parse($scope.data))
        $scope.cancel = () ->
          $modalInstance.dismiss('cancel')
    })
    dialog.result.then((value) ->
        $log.log 'data', value
        $scope.chart.data = value
      )

  $scope.showInModal = () ->
    template = '<div class="modal-header"><button class="btn btn-primary" ng-click="compile()">Compile</button></div>
    <div class="modal-body"><div class="modal-compiled-chart" style="height:500px;"></div></div>
    <div class="modal-footer"></div>'

    dialog = $modal.open({
      size:'lg'
      template:template
      resolve: {
        chart: () -> return currentChart
      }
      controller: ($scope, $modalInstance, $compile, chart) ->
        $scope.compile = () ->
          $scope.chart = emptyChart # ensure data gets cleaned
          chartElem = angular.element(document.querySelector('.modal-compiled-chart'))
          chartElem.children().remove()
          code = chart.code
          compiledChart = $compile(code)($scope)
          $scope.chart = chart
          $scope.filtered = chart.data
          chartElem.append(compiledChart)

    })
  # init

  $scope.fileList = ['f1','f2','f3']
  getFileList()
  $scope.refreshCntr = 0
  if $cookies.lastLoaded
    $scope.openChart($cookies.lastLoaded)

  $scope.scaleMapFn = (value) ->
    $log.log 'scaleMapFn called. value:', value
    return 'red'