class CandidatesSQL {
    constructor(outputToConsole, getResult) {
        this.outputToConsole = outputToConsole
        this.getResult = getResult
        outputToConsole("Created a new UsersSQL")
    }

    getAllUsers(conn, req, res) {
        const GET_ALL_USERS_QUERY = `SELECT * FROM usersData`
        conn.query(GET_ALL_USERS_QUERY, (err, rows) => {
            if (err) {
                this.outputToConsole(`Error in /users GET_ALL_USERS_QUERY: ${GET_ALL_USERS_QUERY}`)
                res.status(500).send(`Error`)
            } else {
                return res.json({
                    data: rows
                })
            }
        })
    }

    searchUsers(conn, req, res) {
        let { text } = req.query

        let SEARCH_USERS_QUERY = `SELECT * FROM usersData WHERE fname LIKE '%${text}%' OR lname LIKE '%${text}%' OR email LIKE '%${text}%'`
        if (!text) { SEARCH_USERS_QUERY = `SELECT * FROM usersData` }
        conn.query(SEARCH_USERS_QUERY, function(err, rows) {
            if (err) {
                res.status(500).send(`Error`)
                this.outputToConsole(`Error in SEARCH_USERS_QUERY in searchUsers: ${SEARCH_USERS_QUERY}`)
            } else {
                res.status(200)
                return res.json({
                    data: rows
                })
            }
        })
    }
}

module.exports = CandidatesSQL