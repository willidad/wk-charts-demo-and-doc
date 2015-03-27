angular.module('app', ['wk.chart', 'ngSanitize', 'ngAnimate', 'ngCookies', 'ui.router','ui.bootstrap','templates', 'hljs', 'ui.select','wk.markdown', 'ui.codemirror'])
  .config(($stateProvider, $urlRouterProvider, menu) ->

    $urlRouterProvider
      .otherwise "/home"

    camelCase = (word) ->
      f = word.substr(0,1).toUpperCase()
      return f + word.substr(1)

    for i in [0..menu.length - 1]
      pName = menu[i].url
      pPath = if menu[i].page then pName else 'default'
      pCtrl = if menu[i].ctrl then camelCase(pName) + 'Ctrl' else 'PageCtrl'

      view =
        views:
          'top':
            templateUrl: 'topnav/top.html'
            controller: 'TopCtrl'
          'left':
            templateUrl: 'left/left.html'
            controller: 'LeftCtrl'
          'content':
            templateUrl: "pages/#{pPath}/page.html"
            controller: pCtrl
          'footer':
            templateUrl: 'footer/footer.html'
            controller: 'FooterCtrl'
        url: "/#{menu[i].url}"
      $stateProvider.state("#{pName}", view)
      if menu[i].tabs
        chartCtrl = if menu[i].chartCtrl then menu[i].chartCtrl else 'ChartCtrl'
        for j in [0 .. menu[i].tabs.length - 1]
          tab = menu[i].tabs[j].url
          if menu[i].tabs[j].ctrl
            ctrl = camelCase(pName) + camelCase(tab) + 'Ctrl'
          else
            ctrl = chartCtrl
          if menu[i].tabs[j].page
            page = "pages/#{pName}/chart.html"
          else
            page = "pages/default/chart.html"
          $stateProvider
            .state("#{pName}.#{tab}",
              {
                templateUrl:  page
                url: '/' + tab
                parent: pName
                controller: ctrl
                data: {pageIdx:i, chartIdx:j,  menuItem:menu[i], tab:menu[i].tabs[j]}
              })
          null
)

angular.module('app').constant 'menu',
  [
    {group:'home', url: 'home', name: 'Home', page:true},
    {group:'charts',url: 'linecharts', name: 'Line Charts', tabs:[
      {url:'horizontal',name:'Horizontal', options:true, ctrl:true},
      {url:'vertical', name:'Vertical', options:true, ctrl:true}
    ]},
    {group:'charts',url: 'areacharts', name: 'Area Charts', tabs:[
      {url:'horizontal',name:'Horizontal', options:true, ctrl:true},
      {url:'vertical',name:'Vertical', options:true, ctrl:true},
      {url:'stackedHorizontal',name:'Stacked Horizontal', options:true, ctrl:true},
      {url:'stackedVertical',name:'Stacked Vertical', options:true, ctrl:true}]}
    {group:'charts',url: 'barcharts', name: 'Bar and Column Charts', tabs:[
      {url:'bar', name:'Bar Chart', options:true},
      {url:'bar-stacked',name:'Stacked Bar', options:true},
      {url:'bar-clustered', name:'Clustered Bar', options:true},
      {url:'column', name:'Column Chart', options:true},
      {url:'column-stacked',name:'Stacked Column', options:true},
      {url:'column-clustered', name:'Clustered Column', options:true}
    ]},
    {group:'charts',url: 'rangecharts', name: 'Range Charts', tabs:[
      {url:'area-horizontal',name:'Range Area Horizontal', options:true},
      {url:'area-vertical',name:'Range Area Vertical', options:true},
      {url:'column',name:'Range Columns', options:true},
      {url:'bars',name:'Range Bars', options:true},
      {url:'boxplot',name:'Box and Whisker Chart', options:true}]}
    {group:'charts',url:'piecharts', name:'Pie Charts', tabs:[
      {url:'pie', name:'Pie', options:true},
      {url:'donat', name:'Donat', options:true}
    ]},
    {group:'charts',url:'histograms', name:'Histograms', tabs:[
      {url:'colFixed', name:'Fixed-width Column', options:true},
      {url:'colVariable', name:'Variable-width Column', options:true}
    ]},
    {group:'charts',url: 'gauges', name: 'Gauges'},
    {group:'charts',url: 'spidercharts', name: 'Spider Charts', tabs: [
      {url:'spider',name:'Spider Chart',options:true}
    ]},
    {group:'charts',url: 'scattercharts', name: 'Scatter Charts', tabs: [
      {url:'bubble', name:'Bubble Chart', options:true, ctrl:true}
      {url:'icon', name:'Icon Chart', options:true}
    ]}
    {group:'charts',url: 'maps', name: 'Georgraphic Maps', tabs:[
      {url:'de', name:'Germany Map', options:true, ctrl:true}
      {url:'world', name:'World Map Orthogrphic', options:true, ctrl:true}
      {url:'worldMercator', name:'World Map Mercator', options:true, ctrl:true}
    ]},
    {group:'charts',url: 'dimensions', name: 'Dimensions', chartCtrl:'DimensionsCtrl', tabs:[
      {url:'x', name:'Horizontal', options:true, page:true},
      {url:'rangeX', name:'Horizontal Range', options:true, page:true},
      {url:'y', name:'Vertical', options:true, page:true},
      {url:'rangeY', name:'Vertical Range', options:true, page:true},
      {url:'color', name:'Color', options:true, page:true},
      {url:'size', name:'Size', options:true, page:true},
      {url:'shape', name:'Shape', options:true, page:true}]},
    {group:'general',url: 'scales', name: 'Scales', tabs:[{url:'quantitative', name:'Quantitative', ctrl:true}, {url:'time', name:'Time', options:true}, {url:'ordinal', name:'Ordinal', ctrl:true},{url:'threshold', name:'Threshold', options:true},{url:'quantize', name:'Quantize'}, {url:'quantile', name:'Quantile'}]},
    {group:'general',url: 'axis', name: 'Axis Styling', tabs:[
      {url:'xaxis', name:'X-Axis', options:true},
      {url:'yaxis', name:'y-Axis'},
      {url:'formatting', name:'Custom Axis Formatting', options:true, ctrl:true}
    ]},
    {group:'general',url: 'legend', name: 'Legends', tabs:[{url:'layer', name:'Layer Legends'},{url:'data', name:'Data Legends'}]},
    {group:'more',url: 'combocharts', name: 'Combocharts'},
    {group:'behavior',url: 'tooltips', name: 'Tooltips', chartCtrl:'TooltipsCtrl', tabs:[
      {url:'tooltips', name:'Tooltips', options:true, page:true}
      {url:'custom', name:'Custom Tooltips', options:true, page:true}
    ]},
    {group:'behavior',url: 'selection', name: 'Selection', tabs:[
      {url:'selection', name:'Pie Selection', options:true}
      {url:'boxplot', name:'Boxplot Selection', options:true}
    ]},
    {group:'behavior',url: 'brushing', name: 'Brushing', tabs:[
      {url:'axisbrush', name:'Axis Brushing', options:true},
      {url:'areabrush', name:'Area Brushing', options:true, ctrl: true},
      {url:'applybrush', name:'Applying Brush to Chart', options:true},
      {url:'multi', name:'Brushing Multiple Charts', options:true, ctrl:true}
      {url:'vertical', name:'Vertical Axis Brushing', options:true}
    ]},
    {group:'more',url: 'model', name: 'ChartModel', page:true, ctrl:true},
    {group:'more',url: 'more', name: 'Chartbuilder and more charts', page:true, ctrl:true}
    {group:'more',url: 'absolute', name: 'position:absolute container', page: true, ctrl:true}
    {group:'more',url: 'chartTest', name: 'Chart Tester', page:true, ctrl:true}
  ]

angular.module('wk.chart').config (wkChartScalesProvider, wkChartLocaleProvider) ->
  wkChartScalesProvider.colors(['grey', 'green','blue','pink','brown'])
  wkChartLocaleProvider.setLocale('de_DE')