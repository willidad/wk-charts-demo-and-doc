angular.module('app').controller 'SelectDataFileCtrl', ($log, $scope, fileList, $modalInstance) ->

  $log.log fileList
  $scope.fileList = fileList.data

  $scope.fileSelected = (file) ->
    $modalInstance.close(file)

