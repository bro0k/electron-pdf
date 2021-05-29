'use strict'
var ipcRender = require('electron').ipcRender
var contextBridge = require('electron').contextBridge

contextBridge.exposeInMainWorld('ipcApi', {
  send: function (event) {
    ipcRender.send(event)
  },
})

var listener = function () {
  window.ipcApi.send('view-ready')
}
document.addEventListener('view-ready', listener)

ipcRender.once('view-ready-ack', function () {
  document.removeEventListener('view-ready', listener)
})
