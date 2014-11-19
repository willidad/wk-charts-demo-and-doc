angular.module('app').controller 'FooterCtrl', ($scope) ->

  $scope.angularVersion = angular.version.full
  $scope.d3Version = d3.version
