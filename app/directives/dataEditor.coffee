angular.module('app').directive 'chartDataEditor', ($log) ->
  return {
    restrict:'E'
    scope:
      data: '='
      filtered: '='
    template: '<div style="height:100%;">
                  <button class="btn btn-default" ng-click="update()">Update Data</button>
                  <button class="btn btn-default" ng-click="shuffle()">Shuffle Data</button>
                  <div class="vertical-scroll-box">
                    <table class="table table-condensed dataEditor">
                      <thead>
                        <tr>
                          <th>
                            <input type="checkbox" ng-model="do20" class="very-narrow">
                          </th>
                          <th ng-repeat="colname in columns " class="narrow">
                            <input type="checkbox" ng-model="checkedCol[$index]">
                            {{colname}}
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr ng-repeat="row in data" class="data-row">
                          <td class="checkboxcol">
                            <input type="checkbox" ng-model="checkedRow[$index]">
                          </td>
                          <td ng-repeat="colname in columns">
                            <input ng-model="row[colname]" class="narrow" ng-class="colname">
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>'

    link: (scope, element, attrs) ->
      scope.columns = []
      scope.checkedRow = []
      scope.checkedCol = []
      scope.do20 = true

      scope.$watch 'data', (val) ->
        if _.isArray(val)
          if _.isObject(val[0])
            scope.columns = _.reject(_.keys(val[0]),(d) -> d is '$$hashKey')

            for i in [0 .. scope.columns.length - 1]
              scope.checkedCol[i] = true
            for i in [0 .. scope.data.length - 1]
              scope.checkedRow[i] = true

            scope.filtered = scope.data.map((d) ->
              r = {}
              for c, i in scope.columns
                if scope.checkedCol[i]
                  r[c] = if typeof d[c] is 'string' and d[c].match /^\{.*\}$/ then scope.$eval(d[c]) else d[c]
                  $log.log(r[c])
              return r
            ).filter((d,i) -> scope.checkedRow[i])

      scope.update = () ->
        scope.filtered = scope.data.map((d) ->
          r = {}
          for c, i in scope.columns
            if scope.checkedCol[i]
              r[c] = if d[c].match /^\{.*\}$/ then scope.$eval(d[c]) else d[c]
          return r
        ).filter((d,i) -> scope.checkedRow[i])
        $log.log scope.filtered


      scope.shuffle = () ->
        scope.filtered = _.shuffle(scope.filtered)

      scope.$watch 'do20', (val) ->
        for i in [0..19]
          scope.checkedRow[i] = val

  }