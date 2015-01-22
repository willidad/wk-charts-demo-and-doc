angular.module('app').controller 'ModelCtrl', ($scope, $log, $modal) ->
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

  $scope.showLayoutDetails = (name, dimension) ->
    modalInstance = $modal.open({
      templateUrl: 'pages/model/dimensionDetails.html'
      controller: 'DimensionDetailsCtrl'
      size:'large'
      resolve: {
        dimension: () ->
          return {name:name, dimension:dimension}
      }
    })
