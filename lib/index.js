'use strict';

const ElectronPDF = require('electron-pdf')
const Promise = require('bluebird');
const express = require('express');
const isAbsoluteUrl = require('is-absolute-url');
const bodyParser = require('body-parser');
const stringScheme = require('./stringScheme');
const util = require('util');
var uuid = require('node-uuid');

const app = express()

const jobOptions = {inMemory: true, closeWindow: false}

function readPrintingOptions(req) {
  const orientation = req.get('x-pdf-orientation');
  const noBackgrounds = req.get('x-pdf-no-backgrounds');
  const margins = req.get('x-pdf-margins');
  const pageSize = req.get('x-pdf-pageSize');
  const waitForJSEvent = req.get('x-pdf-waitForJSEvent');

  let outputWait = req.get('x-pdf-outputWait');
  const printDelay = req.get('x-pdf-printDelay');
  if (!outputWait && printDelay && printDelay > 0) {
    outputWait = printDelay
  }

  const landscape = orientation ? orientation.toLowerCase() === 'landscape' : false;
  const marginsType = margins && {
    none: 1,
    minimum: 2
  }[margins.toLowerCase()] || 0; // default = 0

  return {
    landscape: landscape,
    pageSize: pageSize && pageSize.startsWith('{') ? JSON.parse(pageSize) : pageSize || 'A4',
    printBackground: !noBackgrounds,
    marginsType: marginsType,
    outputWait: outputWait && outputWait > 0 ? outputWait : 0,
    waitForJSEvent: waitForJSEvent ? waitForJSEvent : null
  };
}

function printToPdf(url, options) {
  return exporter.createJob(url, `pdf/${uuid.v4()}.pdf`, options, jobOptions)
}

function printAndRespond(url, req, res, next) {
  const options = readPrintingOptions(req);
  return printToPdf(url, options)
    .then(job => {
      job.on('job-complete', r => {
        res.contentType('application/pdf').send(r.results[0]);
        process.nextTick(() => {
          job.destroy()
        })
      })
      job.render()
    }, next).catch((e) => {
      e.print();
      res.send(e.message).sendStatus(500);
    });
}

app.get('/*', function (req, res, next) {
  let url = req.url.replace(/^\//, '');
  if (url.startsWith("aHR0c")) {
    url = Buffer.from(url, "base64").toString("utf8");
  } else if (!isAbsoluteUrl(url)) {
    return next();
  }

  printAndRespond(url, req, res, next);
})
  .post('/', bodyParser.text({type: '*/*'}), function (req, res, next) {
    Promise.using(stringScheme.withString(req.body || ''), function (url) {
      return printAndRespond(url, req, res, next);
    });
  })
  .use(function (err, req, res, next) { //eslint-disable-line no-unused-vars
    if (err instanceof pool.StatusError) {
      return res.status(400)
        .send(util.format('Url responded with %d', err.code));
    }

    if (err instanceof pool.CefError) {
      return res.status(400)
        .send(util.format('Request failed "%s"', err.code));
    }

    console.error(err.stack);
    res.sendStatus(500);
  })
  .use(function (req, res) {
    res.sendStatus(404);
  });

app.on('before-quit', function (event) {
  // Prevent the app from quitting when the last window closes
  event.preventDefault();
});

const exporter = new ElectronPDF()
exporter.on('charged', () => {
  app.listen(3000, () => {
    console.log(`Export Server running at http://127.0.0.1:3000`)
  })
})

exporter.start()