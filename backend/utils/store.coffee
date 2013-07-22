q = require 'q'

get = (socket,param) ->

  deferred = q.defer()

  # Make the get request
  socket.get param, (err,data) ->
    if err
      deferred.reject(new Error(error))
    else
      deferred.resolve data

  return deferred.promise


set = (socket,param,value) ->

  deferred = q.defer()

  # Make the get request
  socket.set param, value, (err) ->
    if err
      deferred.reject(new Error(error))
    else
      console.log 'done!'
      deferred.resolve value

  return deferred.promise



module.exports =
  get: get
  set: set

