const mysql = require('mysql')
const express = require ('express')
const dotenv = require('dotenv')
const cors = require('cors')
const OktaJwtVerifier = require('@okta/jwt-verifier')

const CandidatesSQL = require('./CandidatesSQL')
const UsersSQL = require('./UsersSQL')

dotenv.config()

const PORT_NO = "4000"

const db_config = {
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASS,
    database: process.env.MYSQL_DB,
}

handleDisconnect()

var conn

function handleDisconnect() {
    conn = mysql.createConnection(db_config);  // Recreate the connection, since the old one cannot be reused.
    conn.connect( function onConnect(err) {   // The server is either down
        if (err) {                                  // or restarting (takes a while sometimes).
            console.log('error when connecting to db:', err);
            setTimeout(handleDisconnect, 10000);    // We introduce a delay before attempting to reconnect,
        } else {
            console.log('db connected')
        }                                          // to avoid a hot loop, and to allow our node script to
    });                                             // process asynchronous requests in the meantime.
                                                    // If you're also serving http, display a 503 error.
        conn.on('error', function onError(err) {
        console.log('db error', err);
        if (err.code + '' === 'PROTOCOL_CONNECTION_LOST') {   // Connection to the MySQL server is usually
            handleDisconnect();                         // lost due to either server restart, or a
        } else {                                        // connnection idle timeout (the wait_timeout
            throw err;                                  // server variable configures this)
        }
    });
}

///////////////////////////////////
////////// FUNCTIONS  /////////////
///////////////////////////////////

function outputToConsole(message) {
    const today = new Date()
    const toWrite = `[${today}] ${message}`
    console.log(toWrite)
}

// Function: executeQuery
// Executes a query, calls callback function on error
// Arguments
//      query: a string of the query to execute
//      callback: the callback function to execute after the query executes
function executeQuery(query, callback) {
    conn.query(query, function (err, rows) {
        if (err) {
            callback(err, null);
        }
        callback(null, rows);
    })
}

// Function: getResult
// Executes a query, passes the results back to the callback function
// Arguments
//      query: a string of the query to execute
//      callback: the callback function to execute after the query executes
function getResult(query, callback) {
    executeQuery(query, function (err, rows) {
       if (!err) {
            callback(null,rows);
       }
       else {
            callback(true,err);
       }
    });
}

///////////////////////////////////
////// APP STARTS HERE ////////////
///////////////////////////////////

const app = express()
app.use(cors())
app.use(express.json())

const oktaJwtVerifier = new OktaJwtVerifier ({
    clientId: process.env.REACT_APP_OKTA_CLIENT_ID,
    issuer: `${process.env.REACT_APP_OKTA_ORG_URL}/oauth2/default`
})

const authenticationRequired = async (req, res, next) => {
    try {
        if (!req.headers.authorization) throw new Error('Authorization header is required')

        const accessToken = req.headers.authorization.trim().split(' ')[1]
        await oktaJwtVerifier.verifyAccessToken(accessToken, 'api://default')
        next()
    } catch (error) {
        next(error.message)
    }
}

const serverCandidateSQL = new CandidatesSQL(outputToConsole, getResult)
const serverUsersSQL = new UsersSQL(outputToConsole, getResult)

app.get('/', (req, res) => {
    res.send("We're live")
})

/////// CANDIDATES ROUTES ////////

app.get('/candidates', authenticationRequired, (req, res) => {
    serverCandidateSQL.getAllCandidates(conn, req, res)
})

app.post('/candidates/new', authenticationRequired, (req, res) => {
    serverCandidateSQL.createNew(conn, req, res)
})

app.post('/candidates/update', authenticationRequired, (req, res) => {
    serverCandidateSQL.updateCandidate(conn, req, res)
})

app.post('/candidates/address/add', authenticationRequired, (req, res) => {
    serverCandidateSQL.addAddressInfo(conn, req, res)
})

app.post('/candidates/address/edit', authenticationRequired, (req, res) => {
    serverCandidateSQL.editAddressInfo(conn, req, res)
})

app.get('/candidates/search', authenticationRequired, (req, res) => {
    serverCandidateSQL.searchCandidates(conn, req, res)
})

app.get('/candidates/excel', authenticationRequired, (req, res) => {
    serverCandidateSQL.getExcelExport(conn, req, res)
})

app.get('/candidates/eduinfo', authenticationRequired, (req, res) => {
    serverCandidateSQL.getEduInfo(conn, req, res)
})

app.post('/candidates/eduinfo/add', authenticationRequired, (req, res) => {
    serverCandidateSQL.addEduInfo(conn, req, res)
})

app.post('/candidates/eduinfo/edit', authenticationRequired, (req, res) => {
    serverCandidateSQL.editEduInfo(conn, req, res)
})

app.post('/candidates/eduinfo/remove', authenticationRequired, (req, res) => {
    serverCandidateSQL.removeEduInfo(conn, req, res)
})

app.get('/candidates/workinfo', authenticationRequired, (req, res) => {
    serverCandidateSQL.getWorkInfo(conn, req, res)
})

app.post('/candidates/workinfo/add', authenticationRequired, (req, res) => {
    serverCandidateSQL.addWorkInfo(conn, req, res)
})

app.post('/candidates/workinfo/edit', authenticationRequired, (req, res) => {
    serverCandidateSQL.editWorkInfo(conn, req, res)
})

app.post('/candidates/workinfo/remove', authenticationRequired, (req, res) => {
    serverCandidateSQL.removeWorkInfo(conn, req, res)
})

app.get('/candidates/addinfo', authenticationRequired, (req, res) => {
    serverCandidateSQL.getAddInfo(conn, req, res)
})

app.post('/candidates/addinfo/add', authenticationRequired, (req, res) => {
    serverCandidateSQL.addAddInfo(conn, req, res)
})

app.post('/candidates/addinfo/edit', authenticationRequired, (req, res) => {
    serverCandidateSQL.editAddInfo(conn, req, res)
})

app.post('/candidates/addinfo/remove', authenticationRequired, (req, res) => {
    serverCandidateSQL.removeAddInfo(conn, req, res)
})

///////// USERS ROUTES ///////////

app.get('/users', authenticationRequired, (req, res) => {
    serverUsersSQL.getAllUsers(conn, req, res)
})

app.get('/users/search', authenticationRequired, (req, res) => {
    serverUsersSQL.searchUsers(conn, req, res)
})

///////// NOTES ROUTES ////////////

app.get('/notes/candidate', authenticationRequired, (req, res) => {
    const { id } = req.query
    const CANDIDATE_NOTES_QUERY = `SELECT * FROM noteData WHERE candidateID=${id}`
    conn.query(CANDIDATE_NOTES_QUERY, (err, rows) => {
        if (err) {
            res.status(500).send('Error')
            outputToConsole(`Error in CANDIDATE_NOTES_QUERY: ${CANDIDATE_NOTES_QUERY}`)
        } else {
            return res.status(200).json({ data: rows })
        }
    })
})

app.post('/notes/add', authenticationRequired, (req, res) => {
    const { message, email, id } = req.body
    const ADD_NOTE_QUERY = `INSERT INTO notes (message, createdByUser, candidate) VALUES ('${message}', (SELECT id FROM users WHERE email = '${email}'), ${id})`
    conn.query(ADD_NOTE_QUERY, (err, rows) => {
        if (err) {
            res.status(500).send('error')
            outputToConsole(`Error in ADD_NOTE_QUERY: ${ADD_NOTE_QUERY}`)
        } else {
            return res.status(200).send('Success')
        }
    })
})

app.post('/notes/remove', authenticationRequired, (req, res) => {
    const { id, email } = req.body
    const REMOVE_NOTE_QUERY = `DELETE FROM notes WHERE id = ${id}`
    conn.query(REMOVE_NOTE_QUERY, (err, rows) => {
        if (err) {
            res.status(500).send('Error')
            outputToConsole(`Error in REMOVE_NOTE_QUERY: ${REMOVE_NOTE_QUERY}`)
        } else {
            return res.status(200).send('Success')
        }
    })
})

app.get('/states', authenticationRequired, (req, res) => {
    const GET_ALL_STATES_QUERY = `SELECT * FROM states`
    conn.query(GET_ALL_STATES_QUERY, (err, rows) => {
        if (err) {
            res.status(500)
            res.send(`Error`)
            console.log(`Error in GET_ALL_STATES_QUERY in /states`)
        } else {
            return(
                res.json({
                    data: rows
                })
            )
        }
    })
})

app.get('/cities', authenticationRequired, (req, res) => {
    const { stateID } = req.query
    const GET_CITIES_QUERY = `SELECT * FROM cities${stateID ? ` WHERE state=${stateID}` : ''} ORDER BY name`
    conn.query(GET_CITIES_QUERY, (err, rows) => {
        if (err) {
            res.status(500).send(`Error in query GET_CITIES_QUERY: ${GET_CITIES_QUERY}`)
            outputToConsole(`Error in query GET_CITIES_QUERY: ${GET_CITIES_QUERY}`)
        } else {
            return(
                res.json({
                    data: rows
                })
            )
        }
    })
})

app.listen(PORT_NO, () => {
    console.log(`Server listening on port: ${PORT_NO}`)
})