angular.module('app').controller 'ModelCtrl', ($scope, $log, $modal, $http) ->
  $scope.$watch 'chartModel' , (value) ->
    $scope.modelJson = JSON.stringify($scope.chartModel, null,'  ')
  , true

  $scope.showDimensionDetails = (name, dimension) ->
    modalInstance = $modal.open({
      templateUrl: 'pages/model/dimensionDetails.html'
      controller: 'DimensionDetailsCtrl'
      size:'large'
      resolve: {
        dimension: () ->
          return {name:name, dimension:dimension}
      }
    })

  $scope.showLayoutDetails = (name, layout) ->
    modalInstance = $modal.open({
      templateUrl: 'pages/model/layoutDetails.html'
      controller: 'LayoutDetailsCtrl'
      size:'large'
      resolve: {
        layout: () ->
          return {name:name, layout:layout}
      }
    })

  $scope.selectDataFile = () ->
    modalInstance = $modal.open({
      templateUrl: 'pages/model/dataFiles.html'
      controller: 'SelectDataFileCtrl'
      size:'lg'
      resolve:{
        fileList: () ->
          return $http.get('/dataFiles')
      }
    })

    modalInstance.result.then((result) ->
      $scope.fileName = result
      d3.csv('dataFiles/' + result, (data) ->
        $scope.chartData = data
        $log.log data
        $scope.dataProperties = _.keys($scope.chartData[0])
        $scope.chartModel.data = 'chartData'
      )
    )
  emptyChart = $scope.chart = {
    code: ''
    data: {}
    scopeVars: {}
  }
  $scope.showChart = (chartMarkup) ->
    template = '<div class="modal-header"></div>
    <div class="modal-body" style="height:600px;"><chart-display code="{{code}}"></chart-display></div></div>
    <div class="modal-footer"><pre>{{selectedArea}} {{selectedObject}}</pre></div>'
    currentChart = chartMarkup
    dialog = $modal.open({
      size:'lg'
      template:template
      resolve: {
        chart: () -> return currentChart
        data: () -> return $scope.chartData
      }
      controller: ($scope, $modalInstance, $compile, chart, data) ->
        $scope.code = chart
        $scope.data = data
        $scope.selectedElement = (element, object) ->
          $log.log element, object
          $scope.selectedArea = element
          $scope.selectedObject = object
    })