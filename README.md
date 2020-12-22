# Elm Http Client App

## Init 
```sh
$ npm install create-elm-app -g
$ create-elm-app elm-http-client-app
```

## Installing JavaScript packages
```sh
$ npm init
$ npm install elm-test --save
```

## Installing Elm packages
```sh
$ elm-app install elm/json
$ elm-app install NoRedInk/elm-json-decode-pipeline
$ elm-app install TSFoster/elm-uuid
$ elm-app install elm/http
$ elm-app install elm/time
$ elm-app install elm/url
$ elm-app install krisajenkins/remotedata
```

## Folder structure

```sh
my-app/
├── .gitignore
├── README.md
├── elm.json
├── elm-stuff
├── products
│   ├── Adapter
│   │   ├── Http
│   │   ├── Json
│   │   └── Json
│   └── Domain
├── public
│   └── index.html
├── src
│   ├── Main.elm
│   ├── index.js
│   ├── main.css
│   └── serviceWorker.js
└── tests
    └── Tests.elm
```

For the project to build, these files must exist with exact filenames:

* `public/index.html` is the page template;
* `src/index.js` is the JavaScript entry point.

## Available scripts

In the project directory you can run:

### `elm-app build`

Builds the app for production to the `build` folder.

The build is minified, and the filenames include the hashes.
Your app is ready to be deployed!

### `elm-app start`

Runs the app in the development mode.

The browser should open automatically to [http://localhost:3000](http://localhost:3000). If the browser does not open, you can open it manually and visit the URL.

The page will reload if you make edits.
You will also see any lint errors in the console.

You may change the listening port number by using the `PORT` environment variable. For example type `PORT=8000 elm-app start ` into the terminal/bash to run it from: [http://localhost:8000/](http://localhost:8000/).

You can prevent the browser from opening automatically,
```sh
elm-app start --no-browser
```

### `elm-app install`

Alias for [`elm install`](http://guide.elm-lang.org/get_started.html#elm-install)

Use it for installing Elm packages from [package.elm-lang.org](http://package.elm-lang.org/)

### `elm-app test`

Run tests with [node-test-runner](https://github.com/rtfeldman/node-test-runner/tree/master)

You can make test runner watch project files by running:

```sh
elm-app test --watch
```