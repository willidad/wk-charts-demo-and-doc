angular.module('app').directive 'chartDataEditor', ($log) ->
  return {
    restrict:'E'
    scope:
      data: '='
      filtered: '='
    template: '<div>
                  <button class="btn btn-default" ng-click="update()">Update Data</button>
                  <table class="table table-condensed dataEditor">
                    <thead>
                      <tr>
                        <th>
                          <input type="checkbox" ng-model="do20">
                        </th>
                        <th ng-repeat="colname in columns " class="narrow">
                          <input type="checkbox" ng-model="checkedCol[$index]">
                          {{colname}}
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr ng-repeat="row in data">
                        <td class="checkboxcol">
                          <input type="checkbox" ng-model="checkedRow[$index]">
                        </td>
                        <td ng-repeat="colname in columns">
                          <input ng-model="row[colname]", class="narrow">
                        </td>
                      </tr>
                    </tbody>
                  </table>
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
                  r[c] = d[c]
              return r
            ).filter((d,i) -> scope.checkedRow[i])

      scope.update = () ->
        scope.filtered = scope.data.map((d) ->
          r = {}
          for c, i in scope.columns
            if scope.checkedCol[i]
              r[c] = d[c]
          return r
        ).filter((d,i) -> scope.checkedRow[i])

      scope.$watch 'do20', (val) ->
        for i in [0..19]
          scope.checkedRow[i] = val

  }