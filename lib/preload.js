'use strict'
var ipcRender = require('electron').ipcRender
var contextBridge = require('electron').contextBridge

contextBridge.exposeInMainWorld('ipcApi', {
  send: function (event) {
    console.log('=======>ipcApi.send')
    ipcRender.send(event)
  },
})

var listener = function () {
  console.log('=====>preload.js----view-ready')
  window.ipcApi.send('view-ready')
}
document.addEventListener('view-ready', listener)

ipcRender.once('view-ready-ack', function () {
  console.log('========>view-ready-ack')
  document.removeEventListener('view-ready', listener)
})

console.log('execute preload.js')
