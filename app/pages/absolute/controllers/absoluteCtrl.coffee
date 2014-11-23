angular.module('app').controller 'AbsoluteCtrl', ($scope, $log, $timeout) ->

  $scope.data = [
    {
      "age": "Under 5 Years",
      "population": "310504"
    },
    {
      "age": "5 to 13 Years",
      "population": "552339"
    },
    {
      "age": "14 to 17 Years",
      "population": "259034"
    },
    {
      "age": "18 to 24 Years",
      "population": "450818"
    },
    {
      "age": "25 to 44 Years",
      "population": "1231572"
    },
    {
      "age": "45 to 64 Years",
      "population": "1215966"
    },
    {
      "age": "65 Years and Over",
      "population": "641667"
    }
  ]

  $scope.containerSize = {position:'absolute', top:'0', left:'0', width:'0', height:'0'}


  $scope.size1 = () ->
      $scope.containerSize = {position:'absolute', top:'15%', left:'10%', width:'40%', height:'50%'}

  $scope.size2 = () ->
    $scope.containerSize = {position:'absolute', top:'30%', left:'10%', width:'60%', height:'40%'}

  $scope.size3 = () ->
    $scope.containerSize = {position:'absolute', top:'0', left:'0', width:'0', height:'0'}