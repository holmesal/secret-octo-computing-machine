app = require('express.io')()
async = require 'async'
app.http().io()

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


# Join a room
app.io.route 'joinRoom', (req) ->

  pushState()

  console.log 'Request to join room: '+req.data.room

  # Get the current room
  req.socket.get 'currentRoom', (err,currentRoom) ->

    # Leave any current rooms
    if currentRoom
      req.io.leave currentRoom
      app.io.room(currentRoom).broadcast 'event',
        type: 'meta'
        text: 'OMG someone left the room: '+currentRoom

    # Set the new room
    req.socket.set 'currentRoom', req.data.room, (err) ->

      # Join the room
      req.io.join req.data.room

      # Broadcast an arrival message
      app.io.room(req.data.room).broadcast 'event',
        type: 'meta'
        text: 'OMG someone joined the room: '+req.data.room



# Send a message
app.io.route 'sendMessage', (req) ->
  # Get the current room
  req.socket.get 'currentRoom', (err,currentRoom) ->
    console.log currentRoom
    # Broadcast to everyone in the current room, including the sender
    app.io.room(currentRoom).broadcast 'event',
      type: 'message'
      text: req.data

app.io.route 'setName', (req) ->
  console.log 'Request to change name!'

# Wait! Listen!
app.listen 7076