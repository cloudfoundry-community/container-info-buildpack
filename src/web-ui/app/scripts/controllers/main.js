'use strict';

angular.module('containerInfoWebUiApp')
    .controller('MainCtrl', function ($scope, $http) {

        $scope.cmd_results = "... remote command results go here ..."

        $scope.execute_command = function (cmd, url) {
            if (url == undefined) {
                var url = "/exec?cmd=" + cmd;
            } else {
                url += cmd;
            }


            $http({ method: 'GET', url: url })
                .success(function (data, status, headers, config) {
                    $scope.cmd = cmd;
                    $scope.cmd_results = data;
                })
                .error(function (data, status, headers, config) {
                    $scope.cmd = cmd;
                    $scope.cmd_results = "Error: status:" + status + ", data:" + data;
                });

        }
    });
