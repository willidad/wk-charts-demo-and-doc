angular.module('app').controller 'LayoutDetailsCtrl', ($log, $scope, $modalInstance, layout) ->
  $log.log layout
  $scope.name = layout.name
  $scope.layout = layout.layout
