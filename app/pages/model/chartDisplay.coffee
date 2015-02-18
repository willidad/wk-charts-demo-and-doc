angular.module('app').directive 'chartDisplay', ($log, $compile) ->
  return {
    restrict:'E'
    scope:
      code: '='
      data: '='
    link: (scope, element, attrs) ->

      scope.$watch 'code', (value) ->
        if value
          element.children().remove()
          compiledChart = $compile(value)(scope.$parent)
          element.append(compiledChart)
  }