angular.module('app').controller 'DimensionDetailsCtrl', ($log, $scope, $modalInstance, dimension) ->
  $log.log dimension
  $scope.name = dimension.name
  $scope.dimension = dimension.dimension
