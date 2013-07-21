'use strict';

angular.module('realtimesteezApp')
  .directive 'message', (socket) ->

    templateUrl: 'views/message.html'
    restrict: 'E'
    link: (scope,element,attrs) ->

      scope.sendMessage = ->
        if scope.data.message
          # Send the message
          socket.emit 'sendMessage',scope.data.message
          # Clear the input
          scope.data.message = ''