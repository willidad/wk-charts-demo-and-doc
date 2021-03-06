angular.module('app').controller 'ChartbuilderLayoutCtrl', ($log, $scope, $state, $templateCache, $compile, $rootScope) ->

  menu = $state.current.data.menuItem
  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}', dim:['x','y','color','size','shape']}"
  $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"
  $scope.chartData = []
  $scope.data = JSON.stringify([], null, 3)


  $scope.dataList = [
    'temperatures.csv',
    'populationByStateAndAge.csv',
    'altersstruktur.csv',
    'populationAge.csv',
    'cars-co2-emissions-trends-by-manufacturer.csv',
    'browsershare.csv',
    'DE Public Spent.csv',
    'ageRanges.csv'
    'celonis.csv'
  ]

  $scope.layoutList =
    [
      {type: 'line', dim:['x','y','color'], prime:'x'},
      {type: 'line-vertical', dim:['x','y','color'], prime:'y'}
      {type: 'area', dim:['x','y','color'], prime:'x'},
      {type: 'area-stacked', dim:['x','y','color'], prime:'x'},
      {type: 'area-vertical', dim:['x','y','color'], prime:'y'},
      {type: 'area-stacked-vertical', dim:['x','y','color'], prime:'y'},
      {type: 'bars', dim:['x','y','color'], prime:'y'},
      {type: 'column', dim:['x','y','color'], prime:'x'},
      {type: 'column-stacked', dim:['x','y','color'], prime:'x'},
      {type: 'column-clusteres', dim:['x','y','color'], prime:'x'},
      {type: 'pie', dim:['color','size'], prime:'size'},
      {type: 'bubble', dim:['x','y','color', 'size'], prime:'x'}
      {type: 'scatter', dim:['x','y','color', 'size', 'shape'], prime:'x'}
      {type: 'spider', dim:['x','y','color'], prime:'x'}
      {type: 'histogram', dim:['range-x','y','color'], prime:'range-x'}
    ]
  
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
    'range-x':{property:'', properties:[], type:undefined , dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', axis:false, ticks:undefined, tickFormat:'', grid:false, showLabel:false, label:''}
    'range-y':{property:'', properties:[], type:undefined , dateFormat:'', exponent:'',range:'', domainRange:'', domain:'', axis:false, ticks:undefined, tickFormat:'', grid:false, showLabel:false, label:''}
  }
  _.assign($scope.options, optionsDefaut)
  $scope.options.dataSelected = false
  $scope.options.layoutSelected = false
  dataRows = []
  $scope.scaleTypes = ['linear', 'time', 'ordinal','category10', 'category20', 'category20b', 'category20b', 'log','pow','sqrt', 'threshold', 'quantize', 'quantile', 'hashed']

  $scope.$watch 'options.chartFile', (name) ->
    _.assign($scope.options, optionsDefaut)
    if name
      d3.csv("data/pages/#{menu.url}/data/#{name}", (rows) ->
        if rows
          dataRows = rows
          $scope.chartData = rows
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
      #$scope.options.templateFile =  "htmlpages/#{menu.url}/templates/#{name}.html"
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
    chartScope.chartData = $scope.chartData


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
    if options.lower and options.lower.length > 0
      def += ' lower-property="' + options.lower + '"'
    if options.upper and options.upper.length > 0
      def += ' upper-property="' + options.upper + '"'
    if options.properties and options.properties.length > 0
      def += ' property="' + options.properties  + '"'
    if options.range
      def += ' range="' + options.range + '"'
    if options.domainRange
      def += ' domain-range="' + options.domainRange + '"'
    if options.domain
      def += ' domain="' + options.domain + '"'
    if options.format
      def += ' format="' + options.format + '"'
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