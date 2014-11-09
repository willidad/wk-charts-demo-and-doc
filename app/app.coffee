angular.module('app', ['ngSanitize','ui.router','ui.bootstrap','templates', 'wk.chart', 'hljs', 'ui.select','wk.markdown'])
  .config(($stateProvider, $urlRouterProvider, menu) ->

    $urlRouterProvider
      .otherwise "/home"

    camelCase = (word) ->
      f = word.substr(0,1).toUpperCase()
      return f + word.substr(1)

    for i in [0..menu.length - 1]
      pName = menu[i].url
      pPath = if menu[i].page then pName else 'default'

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
            controller: "PageCtrl"
          'footer':
            templateUrl: 'footer/footer.html'
            controller: 'FooterCtrl'
        url: "/#{menu[i].url}"
      $stateProvider.state("#{pName}", view)
      if menu[i].tabs
        for j in [0 .. menu[i].tabs.length - 1]
          tab = menu[i].tabs[j].url
          if menu[i].tabs[j].ctrl
            ctrl = camelCase(pName) + camelCase(tab) + 'Ctrl'
          else
            ctrl = 'ChartCtrl'
          if menu[i].tabs[j].page
            page = "pages/#{pName}/chart.html"
          else
            page = "pages/default/chart.html"
          $stateProvider
            .state("#{pName}.#{tab}",
              {
                templateUrl:  page
                url: '/' + tab
                controller: ctrl
                data: {pageIdx:i, chartIdx:j,  menuItem:menu[i], tab:menu[i].tabs[j]}
              })
          null
)

angular.module('app').constant 'menu',
  [
    {url: 'home', name: 'Home', page:true},
    {url: 'linecharts', name: 'Line Charts', tabs:[
      {url:'horizontal',name:'Horizontal', options:true},
      {url:'vertical', name:'Vertical', options:true}
    ]},
    {url: 'areacharts', name: 'Area Charts', tabs:[
      {url:'horizontal',name:'Horizontal'},
      {url:'vertical',name:'Vertical'},
      {url:'stacked-horizontal',name:'Stacked Horizontal', options:true},
      {url:'stacked-vertical',name:'Stacked Vertical'}]}
    {url: 'barcharts', name: 'Bar Charts', tabs:[
      {url:'hor-simple', name:'Horizontally Simple', options:true},
      {url:'hor-stacked',name:'Horizontally Stacked', options:true},
      {url:'hor-clustered', name:'Horizontally Clustered', options:true},
      {url:'vert-simple', name:'Vertically Simple', options:true},
      {url:'vert-stacked',name:'Vertically Stacked', options:true},
      {url:'vert-clustered', name:'Vertically Clustered', options:true}
    ]},
    {url: 'gauges', name: 'Gauges'},
    {url: 'spidercharts', name: 'Spider Charts'},
    {url: 'scattercharts', name: 'Scatter Charts', tabs: [
      {url:'bubble', name:'Bubble Chart', options:true, ctrl:true},
    ]}
    {url: 'maps', name: 'Maps'},
    {url: 'dimensions', name: 'Dimensions', tabs:[{url:'x', name:'Horizontal'},{url:'y', name:'Vertical'},{url:'Color', name:'Color'},{url:'size', name:'Size'},{url:'shape', name:'Shape'}]},
    {url: 'scales', name: 'Scales', tabs:[{url:'quantitative', name:'Quantitative', ctrl:true}, {url:'time', name:'Time', options:true}, {url:'ordinal', name:'Ordinal', ctrl:true},{url:'threshold', name:'Threshold', options:true},{url:'quantize', name:'Quantize'}, {url:'quantile', name:'Quantile'}]},
    {url: 'axis', name: 'Axis Styling', tabs:[
      {url:'xaxis', name:'X-Axis', options:true},
      {url:'yaxis', name:'y-Axis'}
    ]},
    {url: 'legend', name: 'Legends', tabs:[{url:'layer', name:'Layer Legends'},{url:'data', name:'Data Legends'}]},
    {url: 'combocharts', name: 'Combocharts'},
    {url: 'brushing', name: 'Brushing and Selection', tabs:[
      {url:'axisbrush', name:'Axis Brushing', options:true},
      {url:'areabrush', name:'Area Brushing', ctrl: true},
      {url:'selection', name:'Individual Object Selection', options:true},
      {url:'applybrush', name:'Applying Brush to Chart', options:true},
      {url:'multi', name:'Brushing Multiple Charts', ctrl:true}
    ]},
    {url: 'more', name: 'more'}
    {url: 'chartbuilder', name: 'Chart Builder', tabs:[{url:'layout' , name:'Layout Type and Data', ctrl:true, page:true}]}
  ]