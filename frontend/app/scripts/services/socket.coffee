'use strict';

angular.module('realtimesteezApp')
  .factory 'socket', ($rootScope) ->

    socket = io.connect('http://localhost:7076')

    return {

      on: (eventName,callback) ->
        socket.on eventName, (data) ->
          console.log data
          args = arguments
          $rootScope.$apply ->
            callback.apply socket,args

      emit: (eventName,data,callback) ->
        console.log 'emitting: ' +eventName
        socket.emit eventName,data, ->
          console.log arguments
          args = arguments
          $rootScope.$apply ->
            if callback
              callback.apply socket,args

    }