app = require('express.io')()
async = require 'async'
q = require 'q'
store = require './utils/store'
#redis = require 'redis'

# Start the express.io app
app.http().io()

# Start redis
#client = redis.createClient()

pushState = () ->
  # TODO: Add a way to push the current state of the application to each connected client, whenever anything changes
#  console.log app.io.sockets
#  state = {}
#  async.each app.io.sockets,
#    (item)
#    console.log
#
##  app.io.broadcast 'state',



app.io.on 'connection', (socket) ->
  console.log 'New socket connection!'

app.io.on 'disconnection', (socket) ->
  console.log 'Disconnected!!'


# Join a room
app.io.route 'joinRoom', (req) ->

  scope = {}

#  pushState()

  console.log 'Request to join room: '+req.data.room + ' - by: '+req.data.name

  store.get(req.socket,'name')
    .then (name)->
      if req.data.name
        scope.name = req.data.name
      else
        scope.name = name
      # Get the current room
      store.get(req.socket,'room')

    .then (room)->
      scope.room = room
      # If they were already in a room, leave it and send a message
      if room
        req.io.leave room
        app.io.room(room).broadcast 'event',
          type: 'meta'
          text: 'Ladies and gentlemen, '+scope.name+'has left the building.'

      # Set the new room
      store.set(req.socket,'room',req.data.room)

    .then ->
      # Join the room
      req.io.join req.data.room

      # Tell everyone
      app.io.room(req.data.room).broadcast 'event',
        type: 'meta'
        text: 'OMG.'+scope.name+'has joined the room: '+req.data.room

      # Finally, if a name was passed in, set it on the socket
      if req.data.name
        store.set(req.socket,'name',req.data.name)

# Send a message
app.io.route 'sendMessage', (req) ->
  scope = {}
  # Get the current user's name
  store.get(req.socket,'name')

    .then (name) ->
      scope.author = name
      console.log scope.author + ': '+req.data
      # Get the current room
      store.get(req.socket,'room')

    .then (room) ->
      console.log 'sending to '+room
      scope.room = room
      # Broadcast the message
      app.io.room(room).broadcast 'event',
        type: 'message'
        text: req.data
        author: scope.author
      console.log 'sent!'

app.io.route 'changeName', (req) ->
  console.log 'Request to change name to: '+req.data
  # scopeainer for promise vars
  scope = {}
  # Grab the current user's name
  store.get(req.socket,'name')

    .then (name) ->
      scope.oldName = name
      # Change the user's name
      store.set(req.socket,'name',req.data)

    .then (name) ->
      scope.newName = name
      console.log 'Name changed from '+scope.oldName+' to '+name
      # Get the current user's room
      store.get(req.socket,'currentRoom')

    .then (room) ->
      # Tell everyone what's up
      if scope.oldName and scope.oldName != scope.newName
        app.io.room(room).broadcast 'event',
          type: 'meta'
          text: '"'+scope.oldName+'" will henceforth be known as "'+scope.newName+'"'





# Wait! Listen!
app.listen 7076