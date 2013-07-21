'use strict'

angular.module('realtimesteezApp')
  .controller 'MainCtrl', ($scope,$routeParams,socket) ->
    console.log $routeParams.room

    $scope.data =
      events: []
      name: 'Alonso'

    socket.on 'event', (res) ->
      # Add to the event queue
      $scope.data.events.push res

    # Join a room, if it's in the route params
    room = $routeParams.room
    if room
      console.log 'joining room: '+room
      socket.emit 'joinRoom',
        room: room
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ]
