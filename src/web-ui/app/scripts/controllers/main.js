'use strict';

angular.module('containerInfoWebUiApp')
  .controller('MainCtrl', function ($scope, $http) {

    $scope.cmd_results = "... remote command results go here ..."

    $scope.execute_command = function(cmd) {
    	var url = "/exec?cmd="+cmd;
    	$http( { method: 'GET', url: url } )
			  .success(function(data, status, headers, config) {
			    $scope.cmd_results = data;
			  })
			  .error(function(data, status, headers, config) {
			     $scope.cmd_results = "Error: status:" + status + ", data:"+data;
			  });
		
		}
  });
