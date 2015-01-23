angular.module('app').directive 'propertyElement', ($log) ->
  template = "
<span ng-if=\"descriptor.type == \'enum\'\">
  <select ng-model=\"value[name]\" ng-options=\"item for item in descriptor.values\"></select>
</span>
<span ng-switch=\"descriptor\">
  <input ng-switch-when=\"boolean\" ng-model=\"value[name]\" type=\"checkbox\" placeholder=\"{{descriptor}}\">
  <input ng-switch-when=\"number\" ng-model=\"value[name]\" type=\"number\" placeholder=\"{{descriptor}}\">
  <input ng-switch-when=\"string\" ng-model=\"value[name]\" placeholder=\"{{descriptor}}\">
  <input ng-switch-when=\"list\" ng-model=\"value[name]\" placeholder=\"{{descriptor}}\">
  <input ng-switch-when=\"scope variable\" ng-model=\"value[name]\" placeholder=\"{{descriptor}}\">
  <input ng-switch-when=\"scope event\" ng-model=\"value[name]\" placeholder=\"{{descriptor}}\">
  <input ng-switch-when=\"callback\" ng-model=\"value[name]\" placeholder=\"{{descriptor}}\"></span>"

  return {
    restrict: 'E'
    scope:
      descriptor:'='
      value:'='
      name:'@'
    template: template
  }

