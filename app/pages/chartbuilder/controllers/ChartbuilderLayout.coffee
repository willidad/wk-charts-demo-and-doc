angular.module('app').controller 'ChartbuilderLayoutCtrl', ($log, $scope, $state, $templateCache, $compile, $rootScope) ->

  menu = $state.current.data.menuItem
  $scope.chartUrl = "app/pages/#{menu.url}/charts#{$state.current.url}.jade"
  $scope.optionsUrl = "app/pages/#{menu.url}/options#{$state.current.url}.jade"
  

  $scope.dataList = ['temperatures.csv', 'populationByStateAndAge.csv', 'altersstruktur.csv', 'populationAge.csv']
    
  $scope.layoutList =
    [
      {type: 'line', dim:['x','y','color'], prime:'x'},
      {type: 'stacked-bar', dim:['x','y','color'], prime:'x'},
      {type: 'stacked-area', dim:['x','y','color'], prime:'x'},
      {type: 'horizontal-area', dim:['x','y','color'], prime:'y'},
      {type: 'pie', dim:['color','size'], prime:'size'},
      {type: 'simple-bar', dim:['x','y','color'], prime:'x'}]
  
  $scope.options = {}
  optionsDefaut = {
    tooltip:false
    deepWatch: false
    markers:false
    x:{property:'', properties:[], type:undefined , dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', axis:false, ticks:undefined, tickFormat:'', grid:false, showLabel:false, label:''}
    y:{property:'', properties:[],  type:'', dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', axis:false, ticks:undefined, tickFormat:'', grid:false, showLabel:false, label:''}
    color:{property:'', properties:[], type:'', dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', label:'', legend:false, valueLegend:false, legendTitle:''}
    size:{property:'', properties:[], type:'', dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', label:'', legend:false, valueLegend:false, legendTitle:''}
    shape:{property:'', properties:[], type:'', dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', label:'', legend:false, valueLegend:false, legendTitle:''}
  }
  _.assign($scope.options, optionsDefaut)
  $scope.options.dataSelected = false
  $scope.options.layoutSelected = false
  dataRows = []
  $scope.scaleTypes = ['linear', 'time', 'ordinal','category10', 'category20', 'category20b', 'category20b', 'log','pow','sqrt', 'threshold', 'quantize', 'quantile']

  $scope.$watch 'options.chartFile', (name) ->
    _.assign($scope.options, optionsDefaut)
    if name
      d3.csv("/app/pages/#{menu.url}/data/#{name}", (rows) ->
        if rows
          dataRows = rows
          $scope.data = JSON.stringify(rows, null, 3)
          $scope.record = dataRows[0]
          $scope.dataProperties = _.keys(rows[0])
          $scope.options.dataSelected = true
        else
          $scope.chartData = []
          $scope.data = JSON.stringify(rows, null, 3)
          $scope.dataProperties = ""
          $scope.options.dataSelected = false
        $scope.$apply()
      )

  $scope.$watch 'options.layout', (descriptor) ->
    _.assign($scope.options, optionsDefaut)
    if descriptor
      #$scope.options.templateFile =  "app/pages/#{menu.url}/templates/#{name}.jade"
      #template = $templateCache.get($scope.options.templateFile).substr(1)

      #$scope.chartCode = template
      $scope.options.layoutSelected = true
      $scope.dimensions = descriptor.dim

  chartDef = ""
  chartScope = $rootScope.$new(true)
  chartElem = angular.element(document.getElementById(('chartArea')))

  $scope.draw = () ->
    compiledChart = $compile(chartDef)(chartScope)

    chartElem.children().remove()
    chartElem.append(compiledChart)
    chartScope.chartData = dataRows


  buildDimension = (name, options) ->
    def = '\n    <' + name
    if options.type
      def += ' type="' + options.type + '"'
      if options.type is 'time'
        if options.dateFormat
          def += ' date-format="' + options.dateFormat + '"'
      if options.type is 'pow'
        if options.exponent
          def += ' exponent="' + options.exponent + '"'

    if options.property and options.property.length > 0
      def += ' property="' + options.property + '"'
    if options.properties and options.properties.length > 0
      def += ' property="' + options.properties  + '"'
    if options.range
      def += ' range="' + options.range + '"'
    if options.domainRange
      def += ' domain-range="' + options.domainRange + '"'
    if options.domain
      def += ' domain="' + options.domain + '"'
    if options.axis and options.axis isnt 'false'
      def += ' axis'
      if options.axis isnt 'true'
        def += '="' + options.axis + '"'
      if options.ticks
        def += ' ticks="' + options.ticks + '"'
      if options.tickFormat
        def += ' tick-format="' + options.tickFormat + '"'
      if options.grid
        def += ' grid'
      if options.showLabel
        def += ' show-label'
    if options.label
      def += ' label="' + options.label + '"'
    if options.legendType is 'category' or options.legendType is 'data'
      def += if options.legendType is 'category' then ' legend' else ' values-legend'
      if options.legendPos
        if options.legendPos is 'div'
          def += '="' + options.legendDiv + '"'
        else
          def += '="' + options.legendPos + '"'

    def += '></' + name + '>'
    return def


  $scope.$watch 'options', (val) ->
    $log.log val
    chartDef = '<chart'
    if val.dataSelected
      chartDef += ' data="chartData"'
    if val.tooltip
      chartDef += ' tooltips'
    if val.deepWatch
      chartDef += ' deep-watch'
    chartDef += '>'

    chartDef += '\n  <layout ' + val.layout?.type
    # x-axis attributes
    if val.markers 
      chartDef += ' markers'
    
    chartDef += '>'

    if val.layout
      for dim in val.layout.dim
        chartDef += buildDimension(dim, val[dim])

    chartDef += '\n  </layout>'
    chartDef += '\n</chart>'
    $scope.chartCode = chartDef
  ,true