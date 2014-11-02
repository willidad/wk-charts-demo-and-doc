angular.module('app', ['ui.router','ui.bootstrap','app.templates', 'wk.chart', 'hljs', 'ui.select'])
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
            templateUrl: 'app/topnav/top.jade'
            controller: 'TopCtrl'
          'left':
            templateUrl: 'app/left/left.jade'
            controller: 'LeftCtrl'
          'content':
            templateUrl: "app/pages/#{pPath}/page.jade"
            controller: "PageCtrl"
          'footer':
            templateUrl: 'app/footer/footer.jade'
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
            page = "app/pages/#{pName}/chart.jade"
          else
            page = "app/pages/default/chart.jade"
          $stateProvider
            .state("#{pName}.#{tab}",
              {
                templateUrl:  page
                url: '/' + tab
                controller: ctrl
                data: {pageIdx:i, chartIdx:j,  menuItem:menu[i], tab:menu[i].tabs[j]}
              })
)

angular.module('app').constant 'menu',
  [
    {url: 'home', name: 'Home', page:true},
    {url: 'linecharts', name: 'Line Charts', tabs:[{url:'horizontal',name:'Horizontal', options:'md'}, {url:'vertical', name:'Vertical'}]},
    {url: 'areacharts', name: 'Area Charts', tabs:[{url:'horizontal',name:'Horizontal', options:true}, {url:'vertical',name:'Vertical'}]}
    {url: 'barcharts', name: 'Bar Charts', tabs:[{url:'vert-stacked',name:'Vertically Stacked'}, {url:'vert-clustered', name:'Vertically Clustered'}, {url:'vert-simple', name:'Vertically Simple'}]},
    {url: 'gauges', name: 'Gauges'},
    {url: 'spidercharts', name: 'Spider Charts'},
    {url: 'scattercharts', name: 'Scatter Charts'}
    {url: 'maps', name: 'Maps'},
    {url: 'dimensions', name: 'Dimensions', tabs:[{url:'x', name:'Horizontal'},{url:'y', name:'Vertical'},{url:'Color', name:'Color'},{url:'size', name:'Size'},{url:'shape', name:'Shape'}]},
    {url: 'scales', name: 'Scales', tabs:[{url:'quantitative', name:'Quantitative', ctrl:true}, {url:'time', name:'Time'}, {url:'ordinal', name:'Ordinal', ctrl:true},{url:'threshold', name:'Threshold'},{url:'quantize', name:'Quantize'}, {url:'quantile', name:'Quantile'}]},
    {url: 'axis', name: 'Axis Styling', tabs:[{url:'x', name:'X-Axis'},{url:'y', name:'y-Axis'}]},
    {url: 'legend', name: 'Legends', tabs:[{url:'layer', name:'Layer Legends'},{url:'data', name:'Data Legends'}]},
    {url: 'combocharts', name: 'Combocharts'},
    {url: 'brushing', name: 'Brushing and Selection'},
    {url: 'more', name: 'more'}
    {url: 'chartbuilder', name: 'Chart Builder', tabs:[{url:'layout' , name:'Layout Type and Data', ctrl:true, page:true}]}
  ]