angular.module('app').filter 'hasproperties', ()->
  return (input) ->
    if _.isObject(input)
      return _.keys(input).length > 0
    else
      return false