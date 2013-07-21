'use strict'

angular.module('realtimesteezApp', [])
  .config ($routeProvider) ->
    $routeProvider
      .when '/:room',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
