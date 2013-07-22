'use strict'

angular.module('realtimesteezApp')
  .controller 'MainCtrl', ($scope,$routeParams,socket) ->
    console.log $routeParams.room

    $scope.data =
      events: []
      name: localStorage.name

    socket.on 'event', (res) ->
      # Add to the event queue
      $scope.data.events.push res

    # Join a room, if it's in the route params
    room = $routeParams.room
    if room
      console.log 'joining room: '+room
      socket.emit 'joinRoom',
        room:room
        # Pass this to fix a race condition
        name:$scope.data.name


    # Change the name
    $scope.changeName = ->
      console.log $scope.data.name
      if $scope.data.name
        # Socket event
        socket.emit 'changeName',$scope.data.name
        # Update localstorage
        localStorage.name = $scope.data.name