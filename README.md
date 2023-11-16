# electron-pdf

Pdf rendering service with [electron](http://electron.atom.io/)

## Usage

With Docker:

```sh
$ docker run -p 3000:3000 bro0k/electron-pdf
```

Run locally

```sh
$ npm i -g electron-prebuilt
$ electron .
```

## API

### Endpoints

#### `GET /:url`

`url`: Absolute url to the webpage you want to have rendered.

```sh
$ curl http://localhost:3000/https://www.google.com > google.pdf
```

<hr>

#### `POST /`

Send a html string as the request body.

```sh
$ curl -L https://www.google.com | curl -X POST -d @- http://localhost:3000/ > google.pdf
```

### Options

Use following request headers to control the output pdf appearance.

- `x-pdf-orientation`: `landscape` or `portrait` - Page orientation, defaults to `portrait`.
- `x-pdf-no-backgrounds`: Presence of this header prevents backgrounds from being printed.
- `x-pdf-margins`: `default`, `none` or `minimum` - Margin type, defaults to `default`.
- `x-pdf-pageSize`: `A4`, `A3`, `Legal`, `Letter` or `Tabloid` - Paper size, defaults to `A4`.
- `x-pdf-pageSize`: `A4`, `A3`, `Legal`, `Letter` or `Tabloid` - Paper size, defaults to `A4`.
- `x-pdf-outputWait or x-pdf-printDelay`: Time to wait (in MS) between page load and PDF creation. If used in conjunction with -e this will override the default timeout of 10 seconds.
- `x-pdf-waitForJSEvent`: The name of the event to wait before PDF creation .
