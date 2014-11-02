angular.module 'app'
  .controller 'LeftCtrl', ($scope, menu, $state) ->
    $scope.menu = $state.current
    $scope.initial = []
    for m, i in menu
      $scope.initial[i] = if m.tabs then ".#{m.tabs[0].url}" else ''
    $scope.menuItems = menu

    $scope.isActive = (idx) ->
      if idx is $state.current.data?.pageIdx then 'active' else ''