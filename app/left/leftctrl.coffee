angular.module 'app'
  .controller 'LeftCtrl', ($scope, menu) ->
    $scope.initial = []
    for m, i in menu
      $scope.initial[i] = if m.tabs then ".#{m.tabs[0].url}" else ''
    $scope.menuItems = menu