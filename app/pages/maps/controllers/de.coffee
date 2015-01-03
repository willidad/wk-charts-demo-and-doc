angular.module('app').controller 'MapsDeCtrl', ($log, $scope, $templateCache, $state) ->

  menu = $state.current.data.menuItem

  $scope.chartUrl = "pages/#{menu.url}/charts#{$state.current.url}.html"
  options = $state.current.data.tab.options
  if options
    $scope.optionsUrl = "pages/#{menu.url}/options#{$state.current.url}.html"
  $log.log $scope.chartUrl, $scope.optionsUrl

  $scope.chartCode = $templateCache.get($scope.chartUrl)?.substr(1)
  $scope.threshold = [5,10,15,20]

  loadFile = (geoFileName) ->
    d3.json "data/pages/#{menu.url}/data/#{geoFileName}", (geoFile) ->
      $scope.de = geoFile
      $log.log geoFile
      $scope.projection = parmList[geoFileName]
      $scope.genList = geoFile.features.map((p) ->
        {RS:p.properties[$scope.projection.idMap[0]], DES:p.properties[$scope.projection.geoDesc], status: Math.round(Math.random()*20)}
      )
      $scope.jsonData = JSON.stringify($scope.genList, null, 3)
      $scope.$apply()

  parmList = {
    'world100M.json': {
      file: 'world100M.json'
      type: 'geoJson'
      projection: 'orthographic'
      center: [0, 0]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: 90
      scale: 300
      idMap: ['adm0_a3', 'RS']
      geoDesc: 'formal_en'
    }
    'de_laender.geojson' : {
      file: 'de_laender.geojson'
      type: 'geoJson'
      projection: 'mercator'
      center: [10, 51.5]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: null
      scale: 1800
      idMap: ['RS', 'RS']
      geoDesc: 'GEN'
    }
    'uk.json' : {
      file : 'uk.json'
      type: 'geoJson'
      projection: 'mercator'
      center: [-3, 55]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: null
      scale: 2000
      idMap: ['RS', 'RS']
      geoDesc: 'GEN'
    }
    'uk.geojson' : {
      file: 'uk.geojson'
      type: 'geoJson'
      projection: 'mercator'
      center: [-5, 56]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: null
      scale: 1800
      idMap: ['brk_a3', 'RS']
      geoDesc: 'geounit'
    }
  }

  $scope.genList = [{}]
  loadFile('de_laender.geojson')