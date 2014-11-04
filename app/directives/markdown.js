'use strict';
angular.module('wk.markdown' , ['ngSanitize']).directive('md', function ($sanitize) {
    if (typeof hljs !== 'undefined') {
        marked.setOptions({
            highlight: function (code, lang) {
                if (lang) {
                    return hljs.highlight(lang, code).value;
                } else {
                    return hljs.highlightAuto(code).value;
                }
            }
        });
    }
    return {
        restrict: 'E',
        require: '?ngModel',
        link: function ($scope, $elem, $attrs, ngModel) {
            if (!ngModel) {
                var lines = $elem.text().split("\n");
                if (lines.length > 1) {
                    //find the number of leading spaces on the 2nd line and remove these leading spaces form all lines
                    var blankCnt = lines[1].search(/\S/);
                    if (blankCnt >= 0) {
                        var blanks = Array(blankCnt + 1).join(' ');
                        for (var i = 1; i < lines.length; i++) {
                            lines[i] = lines[i].replace(blanks, '');
                        }
                    }
                }
                var text = lines.join("\n");
                var html = $sanitize(marked(text));
                $elem.html(html);
                $elem.addClass('markdown-body')
                return;
            }
            ngModel.$render = function () {
                var html = marked(ngModel.$viewValue || '');
                $elem.html(html);
                $elem.addClass('markdown-body')
            };
        }
    };
});