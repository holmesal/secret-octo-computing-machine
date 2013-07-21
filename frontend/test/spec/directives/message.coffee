'use strict'

describe 'Directive: message', () ->
  beforeEach module 'realtimesteezApp'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<message></message>'
    element = $compile(element) $rootScope
    expect(element.text()).toBe 'this is the message directive'
