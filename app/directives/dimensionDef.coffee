angular.module('app').directive 'dimension', ($log) ->

  return {
    restrict:'E'
    templateUrl:'directives/dimensionDef.html'
    scope:
      name: '@'
      data: '='
      def: "=definition"
      primary: '@'
    link: (scope, element, attrs) ->

      scope.def = {property:[], lower:undefined, upper:undefined, type:undefined , dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', axis:false, ticks:undefined, tickFormat:'', grid:false, showLabel:false, label:'', format:''}

      scope.scaleTypes = ['linear', 'time', 'ordinal','category10', 'category20', 'category20b', 'category20c', 'log','pow','sqrt', 'threshold', 'quantize', 'quantile', 'hashed', 'colors', 'colorsHashed']
      scope.domainRanges = ['min', 'max', 'extent', 'total', 'rangeMin', 'rangeMax', 'rangeExtent']
      scope.showFormat = false
      scope.showExponent = false
      scope.isRange = scope.name is 'range-x' or scope.name is 'range-y'
      isXY = scope.name is 'x' or scope.name is 'y' or scope.name is 'range-x' or scope.name is 'range-y'
      scope.hasAxis = isXY
      scope.hasLegend = not isXY
      scope.showRange = not isXY

      scope.$watch 'primary' ,(val) ->
        if scope.name is val
          #scope.def.property = ''
          scope.isPrimary = true
        else
          scope.def.property = []
          #scope.isPrimary = false

      scope.$watch 'data', (val) ->
        if val
          scope.dataProperties = _.keys(val)

      scope.axisPositions = if scope.name is 'x' then ['false', 'true','top', 'bottom'] else ['false', 'true','left', 'right']

      scope.$watch 'def.type', (val) ->
        scope.showFormat = false
        scope.showExponent = false
        if val is 'time'
          if not _.isDate(scope.data[scope.def.property])
            scope.showFormat = true
        else
          scope.def.dataFormat = ''

        if val is 'pow'
          scope.showExponent = true
        else
          scope.exponent = ''
        scope.showRange = not isXY and not (val in ['category10', 'category20', 'category20b', 'category20b'])

      scope.$watch 'def.axis', (val) ->
        scope.showAxis = val and val isnt 'false'













  }