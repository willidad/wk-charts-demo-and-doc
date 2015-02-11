angular.module('app').directive 'chartDisplay', ($log, $compile) ->
  return {
    restrict:'E'
    link: (scope, element, attrs) ->

      attrs.$observe 'code', (value) ->
        if value
          element.children().remove()
          compiledChart = $compile(value)(scope)
          element.append(compiledChart)
  }