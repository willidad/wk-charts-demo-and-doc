angular.module('app').directive 'validateRange', (modelTypes) ->
  return {
    require: 'ngModel'
    restrict: 'A'
    link: (scope, iElement, iAttrs, ngModelCtrl) ->

      validator = modelTypes.getValidator('list')
      ngModelCtrl.$validators.range = (modelValue) ->
        if ngModelCtrl.$isEmpty(modelValue)
          return true # empty values are considered true
        return validator(modelValue)
  }