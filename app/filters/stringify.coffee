angular.module('app').filter 'stringify', ($log) ->
  return (input) ->
    return JSON.stringify input, null, 3