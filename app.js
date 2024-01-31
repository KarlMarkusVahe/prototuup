const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');

const session = require('express-session');
const mysqlsession = require('express-mysql-session')(session);
const cors = require('cors');

const usersRouter = require('./routes/users');
const documentRouter = require('./routes/documents');
const folderRouter = require('./routes/folders');

const app = express();

const { config } = require('./configuration/database');
const sessionStore = new mysqlsession(config);

app.use(session({
  secret: 'kmk1kik3o1kz_ke-Kwoq-_qw',
  store: sessionStore,
  resave: false,
  saveUninitialized: false,
    cookie: {
      maxAge: 1000 * 60 * 60 * 24 * 7 * 2,
        secure: false,
        httpOnly: false,
    }
}));

const whitelist = ['http://localhost:63342'];
app.use(cors({
     origin: whitelist,
    credentials: true,
    methods: 'PUT, POST, PATCH,FETCH, DELETE, GET',
    exposedHeaders: ['set-cookie']
}));

sessionStore.onReady().then(() => {
  console.log('Sessions initialized.');
}).catch(error => {
  console.error('Sessions uninitialized.');
});

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/users', usersRouter);
app.use('/documents', documentRouter);
app.use('/folders', folderRouter);

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    next(createError(404));
});

app.use(function(err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  res.status(err.status || 500);
});

module.exports = app;
