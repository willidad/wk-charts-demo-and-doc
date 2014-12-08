angular.module 'app'
  .controller 'LeftCtrl', ($scope, menu, $state) ->
    $scope.menu = $state.current
    $scope.initial = []
    for m, i in menu
      $scope.initial[i] = if m.tabs then ".#{m.tabs[0].url}" else ''
    $scope.menuItems = menu

    $scope.isActive = (url) ->
      if url is $state.current.name or url is $state.current.parent then 'active' else ''