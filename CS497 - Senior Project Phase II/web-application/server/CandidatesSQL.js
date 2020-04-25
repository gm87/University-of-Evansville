const Excel = require('exceljs')

class CandidatesSQL {
    constructor(outputToConsole, getResult) {
        this.outputToConsole = outputToConsole
        this.getResult = getResult
        outputToConsole("Created a new CandidatesSQL")
    }

    buildSearchQuery(text) {
        var query = ""
        if (text === "" || text === null) {
            return "SELECT * FROM candidateData ORDER BY lname"
        } else {
            return `SELECT * FROM candidateData WHERE fname LIKE '%${text}%' OR lname LIKE '%${text}%' OR email LIKE '%${text}%' OR phone LIKE '%${text}%' OR city LIKE '%${text}%' OR stateName LIKE '%${text}%' OR postal LIKE '%${text}%' ORDER BY lname`
        }
    }

    getAllCandidates(conn, req, res) {
        const GET_ALL_CANDIDATES_QUERY = `SELECT * FROM candidateData ORDER BY lname`
        conn.query(GET_ALL_CANDIDATES_QUERY, (err, rows) => {
            if (err){
                this.outputToConsole(`Error in GET_ALL_CANDIDATES_QUERY`)
                res.status(500).send('Error getting candidates data')
            } else {
                return res.status(200).json({
                    data: rows
                })
            }
        })
    }

    createNew(conn, req, res) {
        const self = this
        const { fName, lName, email, phone, address1, address2, cityId, stateId, postal, workExperience, educationInfo, additionalInfo, sourceLocationLat, sourceLocationLong, addedByEmail } = req.body
        let nums = ''
        let insertPhone = ''
        try {
            if (phone.length > 0) {
                for (let i = 0; i<phone.length; i++) {
                    if (!isNaN(parseInt(phone[i])))
                        nums += phone[i]
                }
                nums = nums.substr(nums.length - 10, 10)
                insertPhone += nums.substr(0, 3) + "-" + nums.substr(3, 3) + '-' + nums.substr(6, 4)
            }
        } catch {
            insertPhone = ''
            console.log(`Couldn't get phone number`)
        }
        
        if (address1.length > 0) {
            const INSERT_CANDIDATE_ADDRESS_QUERY = `INSERT INTO candidateAddresses (address1, address2, state, city, postal) VALUES ('${address1}', ${address2.length > 0 ? `'${address2}'` : 'NULL'}, ${stateId}, '${cityId}', '${postal}')`
            this.outputToConsole(`fName: ${fName} \nlName: ${lName}\n email: ${email}\n phone: ${phone}\n address1: ${address1}\n address2: ${address2}\n cityId: ${cityId}\n stateId: ${stateId}\n additionalInfo: ${JSON.stringify(additionalInfo)}\n workExperience: ${JSON.stringify(workExperience)}\n educationInfo: ${JSON.stringify(educationInfo)}\n sourceLocationLat: ${sourceLocationLat} \nsourceLocationLong: ${sourceLocationLong}`)
            this.getResult(INSERT_CANDIDATE_ADDRESS_QUERY, function(err, rows) {
                if (err) {
                    self.outputToConsole(`Error in INSERT_CANDIDATE_ADDRESS_QUERY in candidates/add: ${INSERT_CANDIDATE_ADDRESS_QUERY}`)
                    res.status(500)
                    res.send(`Error`)
                } else {
                    const addressID = rows.insertId
                    const INSERT_CANDIDATE_QUERY = `INSERT INTO candidates (fName, lName, email, phone, address, sourceLocationLat, sourceLocationLong, addedByUser) VALUES ('${fName}', '${lName}', ${email.length > 0 ? `'${email}'` : 'NULL'}, ${insertPhone.length > 0 ? `'${insertPhone}'` : 'NULL'}, ${addressID}, ${sourceLocationLat}, ${sourceLocationLong}, (SELECT id FROM users WHERE email = '${addedByEmail}'))`
                    self.getResult(INSERT_CANDIDATE_QUERY, function(err, rows) {
                        if (err) {
                            self.outputToConsole(`Error in INSERT_CANDIDATE_QUERY in candidates/add: ${INSERT_CANDIDATE_QUERY}`)
                            res.status(500)
                            res.send(`Error`)
                        } else {
                            const candidateID = rows.insertId
                            workExperience.forEach(x => {
                                console.log(`workExperience: ${JSON.stringify(x)}`)
                                const beginDate = new Date((x.beginDate * 1000) + 978264705000)
                                const endDate = new Date((x.endDate * 1000) + 978264705000)
                                const INSERT_WORK_EXP_QUERY = `INSERT INTO workExperience (candidateID, name, beginDate, endDate, summary, title) VALUES (${candidateID}, '${x.name}',
                                                                '${beginDate}', '${endDate}', '${x.summary}', '${x.title}')`
                                console.log(`INSERT_WORK_EXP_QUERY: ${INSERT_WORK_EXP_QUERY}`)
                            })
                            educationInfo.forEach(x => {
                                console.log(`educationInfo: ${JSON.stringify(x)}`)
                                const beginDate = new Date((x.beginDate * 1000) + 978264705000)
                                const endDate = new Date((x.endDate * 1000) + 978264705000)
                                const INSERT_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES
                                                                (${candidateID}, , '${beginDate}', '${endDate}', '${x.summary}', )` /* Need to get institution ID and degree ID */
                                console.log(`INSERT_EDU_INFO_QUERY: ${INSERT_EDU_INFO_QUERY}`)
                            })
                            additionalInfo.forEach(x => {
                                console.log(`additionalInfo: ${JSON.stringify(x)}`)
                                const INSERT_ADD_INFO_QUERY = `INSERT INTO additionalInfo (candidateID, title, description) VALUES (${candidateID}, '${x.title}', '${x.description}')`
                                console.log(`INSERT_ADD_INFO_QUERY: ${INSERT_ADD_INFO_QUERY}`)
                            })
                            res.status(200).send("Success")
                        }
                    })
                }
            })
        } else {
            const INSERT_CANDIDATE_QUERY = `INSERT INTO candidates (fName, lName, email, phone, sourceLocationLat, sourceLocationLong, addedByUser) VALUES ('${fName}', '${lName}', ${email.length > 0 ? `'${email}'` : 'NULL'}, ${insertPhone.length > 0 ? `'${insertPhone}'` : 'NULL'}, ${sourceLocationLat}, ${sourceLocationLong}, (SELECT id FROM users WHERE email = '${addedByEmail}'))`
            self.getResult(INSERT_CANDIDATE_QUERY, function(err, rows) {
                if (err) {
                    self.outputToConsole(`Error in INSERT_CANDIDATE_QUERY in candidates/add: ${INSERT_CANDIDATE_QUERY}`)
                    res.status(500).send(`Error`)
                } else {
                    const candidateID = rows.insertId
                    workExperience.forEach(x => {
                        const beginDate = new Date((x.beginDate * 1000) + 978264705000)
                        const endDate = new Date((x.endDate * 1000) + 978264705000)
                        const INSERT_WORK_EXP_QUERY = `INSERT INTO workExperience (candidateID, name, beginDate, endDate, summary, title) VALUES (${candidateID}, '${x.name}',
                                                        '${beginDate}', '${endDate}', '${x.summary}', '${x.title}')`
                        self.getResult(INSERT_WORK_EXP_QUERY, (err, rows) => {
                            if (err) {
                                self.outputToConsole(`Error in INSERT_WORK_EXP_QUERY: ${INSERT_WORK_EXP_QUERY}`)
                                res.status(500).send('Error')
                            }
                        })
                    })
                    educationInfo.forEach(x => {
                        const beginDate = new Date((x.beginDate * 1000) + 978264705000)
                        const endDate = new Date((x.endDate * 1000) + 978264705000)
                        const GET_INSTITUTION_QUERY = `SELECT id FROM institutions WHERE name LIKE '%${x.institution}%'`
                        self.getResult(GET_INSTITUTION_QUERY, (err, rows) => {
                            if (err) {
                                self.outputToConsole(`Error in GET_INSTITUTION_QUERY: ${GET_INSTITUTION_QUERY}`)
                                res.status(500).send('Error')
                            } else {
                                if (rows.length > 0) {
                                    const institutionId = rows[0].id
                                    const GET_DEGREE_ID_QUERY = `SELECT id FROM degrees WHERE type=${x.degreeRow} AND field LIKE '%${x.fieldOfStudy}%'`
                                    self.getResult(GET_DEGREE_ID_QUERY, (err, rows) => {
                                        if (err) {
                                            self.outputToConsole(`Error in GET_DEGREE_ID_QUERY: ${GET_DEGREE_ID_QUERY}`)
                                            res.status(500).send('Error')
                                        } else {
                                            if (rows.length > 0) {
                                                const degreeId = rows[0].id
                                                const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateID}, ${institutionId}, '${beginDate}', '${endDate}', '${x.summary}', ${degreeId})`
                                                self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                                    if (err) {
                                                        self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                                    }
                                                })
                                            } else {
                                                const INSERT_DEGREE_QUERY = `INSERT INTO degrees (type, field) VALUES (${x.degreeRow}, '${x.fieldOfStudy}')`
                                                self.getResult(INSERT_DEGREE_QUERY, (err, rows) => {
                                                    if (err) {
                                                        self.outputToConsole(`Error in INSERT_DEGREE_QUERY: ${INSERT_DEGREE_QUERY}`)
                                                        res.status(500).send('Error')
                                                    } else {
                                                        const degreeId = rows.insertId
                                                        const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateID}, ${institutionId}, '${beginDate}', '${endDate}', '${x.summary}', ${degreeId})`
                                                        self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                                            if (err) {
                                                                self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        }
                                    })
                                } else {
                                    const INSERT_INSTITUTION_QUERY = `INSERT INTO institutions (name) VALUES ('${x.institution}')`
                                    self.getResult(INSERT_INSTITUTION_QUERY, (err, rows) => {
                                        if (err) {
                                            self.outputToConsole(`Error in INSERT_INSTITUTION_QUERY: ${INSERT_INSTITUTION_QUERY}`)
                                            res.status(500).send('Error')
                                        } else {
                                            const institutionId = rows.insertId
                                            const GET_DEGREE_ID_QUERY = `SELECT id FROM degrees WHERE type=${x.degreeRow} AND field LIKE '%${x.fieldOfStudy}%'`
                                            self.getResult(GET_DEGREE_ID_QUERY, (err, rows) => {
                                                if (err) {
                                                    self.outputToConsole(`Error in GET_DEGREE_ID_QUERY: ${GET_DEGREE_ID_QUERY}`)
                                                    res.status(500).send('Error')
                                                } else {
                                                    if (rows.length > 0) {
                                                        const degreeId = rows[0].id
                                                        const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateID}, ${institutionId}, '${beginDate}', '${endDate}', '${x.summary}', ${degreeId})`
                                                        self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                                            if (err) {
                                                                self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                                            }
                                                        })
                                                    } else {
                                                        const INSERT_DEGREE_QUERY = `INSERT INTO degrees (type, field) VALUES (${x.degreeRow}, '${x.fieldOfStudy}')`
                                                        self.getResult(INSERT_DEGREE_QUERY, (err, rows) => {
                                                            if (err) {
                                                                self.outputToConsole(`Error in INSERT_DEGREE_QUERY: ${INSERT_DEGREE_QUERY}`)
                                                                res.status(500).send('Error')
                                                            } else {
                                                                const degreeId = rows.insertId
                                                                const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateID}, ${institutionId}, '${beginDate}', '${endDate}', '${x.summary}', ${degreeId})`
                                                                self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                                                    if (err) {
                                                                        self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                                                    }
                                                                })
                                                            }
                                                        })
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                            }
                        })
                    })
                    additionalInfo.forEach(x => {
                        const INSERT_ADD_INFO_QUERY = `INSERT INTO additionalInfo (candidateID, title, description) VALUES (${candidateID}, '${x.title}', '${x.description}')`
                        self.getResult(INSERT_ADD_INFO_QUERY, (err, rows) => {
                            if (err) {
                                self.outputToConsole(`Error in INSERT_ADD_INFO_QUERY: ${INSERT_ADD_INFO_QUERY}`)
                                res.status(500).send('Error')
                            }
                        })
                    })
                    res.status(200).send("Success")
                }
            })
        }
    }

    addAddressInfo(conn, req, res) {
        const { address1, address2, city, state, postal, candidateID } = req.body
        const INSERT_ADDRESS_QUERY = `INSERT INTO candidateAddresses (address1, address2, state, city, postal) VALUES ('${address1}', ${address2 && address2.length > 0 ? `'${address2}'` : 'NULL'}, ${state}, ${city}, '${postal}')`
        const self = this
        this.getResult(INSERT_ADDRESS_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in INSERT_ADDRESS_QUERY: ${INSERT_ADDRESS_QUERY}`)
                res.status(500).send('Error')
            } else {
                const addressID = rows.insertId
                const UPDATE_CANDIDATE_ADDRESS_QUERY = `UPDATE candidates SET address=${addressID} WHERE id=${candidateID}`
                self.getResult(UPDATE_CANDIDATE_ADDRESS_QUERY, (err, rows) => {
                    if (err) {
                        self.outputToConsole(`Error in UPDATE_CANDIDATE_ADDRESS_QUERY: ${UPDATE_CANDIDATE_ADDRESS_QUERY}`)
                        res.status(500).send('Error')
                    } else {
                        res.status(200).send('Success')
                    }
                })
            }
        })
    }

    editAddressInfo(conn, req, res) {
        const { address1, address2, city, state, postal, addressID } = req.body
        const UPDATE_ADDRESS_QUERY = `UPDATE candidateAddresses SET address1='${address1}', address2=${address2 && address2.length > 0 ? `'${address2}'` : 'NULL'}, city=${city}, state=${state}, postal='${postal}' WHERE id=${addressID}`
        this.getResult(UPDATE_ADDRESS_QUERY, (err, rows) => {
            if (err) {
                this.outputToConsole(`Error in UPDATE_ADDRESS_QUERY: ${UPDATE_ADDRESS_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    getEduInfo(conn, req, res) { 
        const { id } = req.query
        const GET_EDU_INFO_QUERY = `SELECT * FROM eduData WHERE candidateID = ${id}`
        conn.query(GET_EDU_INFO_QUERY, (err, rows) => {
            if (err) {
                res.status(500).send('error')
                this.outputToConsole(`Error in GET_EDU_INFO_QUERY: ${GET_EDU_INFO_QUERY}`)
            } else {
                res.status(200).json({ data: rows })
            }
        })
    }

    addEduInfo(conn, req, res) {
        const { candidateId, degree, field, institution, beginDate, endDate, summary } = req.body
        let insertBeginDate = `${beginDate}-01 00:00:00`
        let insertEndDate = `${endDate}-01 00:00:00`
        const self = this
        const GET_INSTITUTION_QUERY = `SELECT id FROM institutions WHERE name LIKE '%${institution}%'`
        this.getResult(GET_INSTITUTION_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in GET_INSTITUTION_QUERY: ${GET_INSTITUTION_QUERY}`)
                res.status(500).send('Errror')
            } else {
                if (rows.length > 0) {
                    const institutionId = rows[0].id
                    const GET_DEGREE_ID_QUERY = `SELECT id FROM degrees WHERE type=${degree} AND field LIKE '%${field}%'`
                    self.getResult(GET_DEGREE_ID_QUERY, (err, rows) => {
                        if (err) {
                            self.outputToConsole(`Error in GET_DEGREE_ID_QUERY: ${GET_DEGREE_ID_QUERY}`)
                        } else {
                            if (rows.length > 0) {
                                const degreeId = rows[0].id
                                const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateId}, ${institutionId}, '${insertBeginDate}', '${insertEndDate}', '${summary}', ${degreeId})`
                                self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                    if (err) {
                                        self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                    } else {
                                        res.status(200).send('Success!')
                                    }
                                })
                            } else {
                                const INSERT_DEGREE_QUERY = `INSERT INTO degrees (type, field) VALUES (${degree}, '${field}')`
                                self.getResult(INSERT_DEGREE_QUERY, (err, rows) => {
                                    if (err) {
                                        self.outputToConsole(`Error in INSERT_DEGREE_QUERY: ${INSERT_DEGREE_QUERY}`)
                                    } else {
                                        const degreeId = rows.insertId
                                        const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateId}, ${institutionId}, '${insertBeginDate}', '${insertEndDate}', '${summary}', ${degreeId})`
                                        self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                            if (err) {
                                                self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                            } else {
                                                res.status(200).send('Success!')
                                            }
                                        })
                                    }
                                })
                            }
                        }
                    })
                } else {
                    const INSERT_INSTITUTION_QUERY = `INSERT INTO institutions (name) VALUES ('${institution}')`
                    self.getResult(INSERT_INSTITUTION_QUERY, (err, rows) => {
                        if (err) {
                            self.outputToConsole(`Error in INSERT_INSTITUTION_QUERY: ${INSERT_INSTITUTION_QUERY}`)
                        } else {
                            const institutionId = rows.insertId
                            const GET_DEGREE_ID_QUERY = `SELECT id FROM degrees WHERE type=${degree} AND field LIKE '${field}'`
                            self.getResult(GET_DEGREE_ID_QUERY, (err, rows) => {
                                if (err) {
                                    self.outputToConsole(`Error in GET_DEGREE_ID_QUERY: ${GET_DEGREE_ID_QUERY}`)
                                    res.status(500).send('Error')
                                } else {
                                    if (rows.length > 0) {
                                        const degreeId = rows[0].id
                                        const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateId}, ${institutionId}, '${insertBeginDate}', '${insertEndDate}', '${summary}', ${degreeId})`
                                        self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                            if (err) {
                                                self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                                res.status(500).send('Error')
                                            } else {
                                                res.status(200).send('Success')
                                            }
                                        })
                                    } else {
                                        const INSERT_DEGREE_QUERY = `INSERT INTO degrees (type, field) VALUES (${degree}, '${field}')`
                                        self.getResult(INSERT_DEGREE_QUERY, (err, rows) => {
                                            if (err) {
                                                self.outputToConsole(`Error in INSERT_DEGREE_QUERY: ${INSERT_DEGREE_QUERY}`)
                                                res.status(500).send('Error')
                                            } else {
                                                const degreeId = rows.insertId
                                                const ADD_EDU_INFO_QUERY = `INSERT INTO educationInfo (candidateID, institution, beginDate, endDate, summary, degree) VALUES (${candidateId}, ${institutionId}, '${insertBeginDate}', '${insertEndDate}', '${summary}', ${degreeId})`
                                                self.getResult(ADD_EDU_INFO_QUERY, (err, rows) => {
                                                    if (err) {
                                                        self.outputToConsole(`Error in ADD_EDU_INFO_QUERY: ${ADD_EDU_INFO_QUERY}`)
                                                        res.status(500).send('Error')
                                                    } else {
                                                        res.status(200).send('Success')
                                                    }
                                                })
                                            }
                                        })
                                    }
                                }
                            })
                        }
                    })
                }
            }
        })
    }

    editEduInfo(conn, req, res) {
        const { id, degree, field, institution, beginDate, endDate, summary } = req.body
        let insertBeginDate = `${beginDate}-01 00:00:00`
        let insertEndDate = `${endDate}-01 00:00:00`
        const GET_DEGREE_ID_QUERY = `SELECT id FROM degrees WHERE type=${degree} AND field LIKE '%${field}%'`
        const self = this
        this.getResult(GET_DEGREE_ID_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in GET_DEGREE_ID_QUERY: ${GET_DEGREE_ID_QUERY}`)
                res.status(500).send('Error')
            } else {
                if (rows.length > 0) {
                    const degreeId = rows[0].id
                    const GET_INSTITUTION_QUERY = `SELECT id FROM institutions WHERE name LIKE '%${institution}%'`
                    self.getResult(GET_INSTITUTION_QUERY, (err, rows) => {
                        if (err) {
                            self.outputToConsole(`Error in GET_INSTITUTION_QUERY: ${GET_INSTITUTION_QUERY}`)
                            res.status(500).send('Error')
                        } else {
                            if (rows.length > 0) {
                                const institutionId = rows[0].id
                                const UPDATE_EDU_INFO_QUERY = `UPDATE educationInfo SET institution=${institutionId}, beginDate='${insertBeginDate}', endDate='${insertEndDate}', summary='${summary}', degree=${degreeId} WHERE id=${id}`
                                self.getResult(UPDATE_EDU_INFO_QUERY, (err, rows) => {
                                    if (err) {
                                        self.outputToConsole(`Error in UPDATE_EDU_INFO_QUERY: ${UPDATE_EDU_INFO_QUERY}`)
                                        res.status(500).send('Error')
                                    } else {
                                        res.status(200).send('Success')
                                    }
                                })
                            } else {
                                const INSERT_INSTITUTION_QUERY = `INSERT INTO institutions (name) VALUES ('${institution}')`
                                self.getResult(INSERT_INSTITUTION_QUERY, (err, rows) => {
                                    if (err) {
                                        self.outputToConsole(`Error in INSERT_INSTITUTION_QUERY: ${INSERT_INSTITUTION_QUERY}`)
                                        res.status(500).send('Error')
                                    } else {
                                        const institutionId = rows.insertId
                                        const UPDATE_EDU_INFO_QUERY = `UPDATE educationInfo SET institution=${institutionId}, beginDate='${insertBeginDate}', endDate='${insertEndDate}', summary='${summary}', degree=${degreeId} WHERE id=${id}`
                                        self.getResult(UPDATE_EDU_INFO_QUERY, (err, rows) => {
                                            if (err) {
                                                self.outputToConsole(`Error in UPDATE_EDU_INFO_QUERY: ${UPDATE_EDU_INFO_QUERY}`)
                                                res.status(500).send('Error')
                                            } else {
                                                res.status(200).send('Success')
                                            }
                                        })
                                    }
                                })
                            }
                        }
                    })
                } else {
                    const INSERT_DEGREE_QUERY = `INSERT INTO degrees (type, field) VALUES (${degree}, '${field}')`
                    self.getResult(INSERT_DEGREE_QUERY, (err, rows) => {
                        if (err) {
                            self.outputToConsole(`Error in INSERT_DEGREE_QUERY: ${INSERT_DEGREE_QUERY}`)
                            res.status(500).send('Error')
                        } else {
                            const degreeId = rows.insertId
                            const GET_INSTITUTION_QUERY = `SELECT id FROM institutions WHERE name LIKE '%${institution}%'`
                            self.getResult(GET_INSTITUTION_QUERY, (err, rows) => {
                                if (err) {
                                    self.outputToConsole(`Error in GET_INSTITUTION_QUERY: ${GET_INSTITUTION_QUERY}`)
                                    res.status(500).send('Error')
                                } else {
                                    if (rows.length > 0) {
                                        const institutionId = rows[0].id
                                        const UPDATE_EDU_INFO_QUERY = `UPDATE educationInfo SET institution=${institutionId}, beginDate='${insertBeginDate}', endDate='${insertEndDate}', summary='${summary}', degree=${degreeId} WHERE id=${id}`
                                        self.getResult(UPDATE_EDU_INFO_QUERY, (err, rows) => {
                                            if (err) {
                                                self.outputToConsole(`Error in UPDATE_EDU_INFO_QUERY: ${UPDATE_EDU_INFO_QUERY}`)
                                                res.status(500).send('Error')
                                            } else {
                                                res.status(200).send('Success')
                                            }
                                        })
                                    } else {
                                        const INSERT_INSTITUTION_QUERY = `INSERT INTO institutions (name) VALUES ('${institution}')`
                                        self.getResult(INSERT_INSTITUTION_QUERY, (err, rows) => {
                                            if (err) {
                                                self.outputToConsole(`Error in INSERT_INSTITUTION_QUERY: ${INSERT_INSTITUTION_QUERY}`)
                                                res.status(500).send('Error')
                                            } else {
                                                const institutionId = rows.insertId
                                                const UPDATE_EDU_INFO_QUERY = `UPDATE educationInfo SET institution=${institutionId}, beginDate='${insertBeginDate}', endDate='${insertEndDate}', summary='${summary}', degree=${degreeId} WHERE id=${id}`
                                                self.getResult(UPDATE_EDU_INFO_QUERY, (err, rows) => {
                                                    if (err) {
                                                        self.outputToConsole(`Error in UPDATE_EDU_INFO_QUERY: ${UPDATE_EDU_INFO_QUERY}`)
                                                        res.status(500).send('Error')
                                                    } else {
                                                        res.status(200).send('Success')
                                                    }
                                                })
                                            }
                                        })
                                    }
                                }
                            })
                        }
                    })
                }
            }
        })
    }

    removeEduInfo(conn, req, res) {
        const { id } = req.body
        const REMOVE_EDU_INFO_QUERY = `DELETE FROM educationInfo WHERE id=${id}`
        const self=this
        self.getResult(REMOVE_EDU_INFO_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in REMOVE_EDU_INFO_QUERY: ${REMOVE_EDU_INFO_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    getWorkInfo(conn, req, res) {
        const { id } = req.query
        const GET_WORK_INFO_QUERY = `SELECT * FROM workData WHERE candidateID = ${id}`
        conn.query(GET_WORK_INFO_QUERY, (err, rows) => {
            if (err) {
                res.status(500).send('error')
                this.outputToConsole(`Error in GET_WORK_INFO_QUERY: ${GET_WORK_INFO_QUERY}`)
            } else {
                res.status(200).json({ data: rows })
            }
        })
    }

    addWorkInfo(conn, req, res) {
        const { candidateId, workplace, title, beginDate, endDate, summary } = req.body
        let insertBeginDate = `${beginDate}-01 00:00:00`
        let insertEndDate = `${endDate}-01 00:00:00`
        const ADD_WORK_INFO_QUERY = `INSERT INTO workExperience (candidateID, name, beginDate, endDate, summary, title) VALUES (${candidateId}, '${workplace}', '${insertBeginDate}', '${insertEndDate}', '${summary}', '${title}')`
        const self = this
        this.getResult(ADD_WORK_INFO_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in ADD_WORK_INFO_QUERY: ${ADD_WORK_INFO_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    editWorkInfo(conn, req, res) {
        const { id, workplace, title, beginDate, endDate, summary } = req.body
        let insertBeginDate = `${beginDate}-01 00:00:00`
        let insertEndDate = `${endDate}-01 00:00:00`
        const UPDATE_WORK_INFO_QUERY = `UPDATE workExperience SET name='${workplace}', title='${title}', beginDate='${insertBeginDate}', endDate='${insertEndDate}', summary='${summary}' WHERE id=${id}`
        const self = this
        self.getResult(UPDATE_WORK_INFO_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in UPDATE_WORK_INFO_QUERY: ${UPDATE_WORK_INFO_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    removeWorkInfo(conn, req, res) {
        const { id } = req.body
        const REMOVE_WORK_INFO_QUERY = `DELETE FROM workExperience WHERE id=${id}`
        const self = this
        self.getResult(REMOVE_WORK_INFO_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in REMOVE_WORK_INFO_QUERY: ${REMOVE_WORK_INFO_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    getAddInfo(conn, req, res) {
        const { id } = req.query
        const GET_ADD_INFO_QUERY = `SELECT * FROM addInfoData WHERE candidateID = ${id}`
        conn.query(GET_ADD_INFO_QUERY, (err, rows) => {
            if (err) {
                res.status(500).send('error')
                this.outputToConsole(`Error in GET_ADD_INFO_QUERY: ${GET_ADD_INFO_QUERY}`)
            } else {
                res.status(200).json({ data: rows })
            }
        })
    }

    addAddInfo(conn, req, res) {
        const { candidateId, title, description } = req.body
        const ADD_ADD_INFO_QUERY = `INSERT INTO additionalInfo (candidateID, title, description) VALUES (${candidateId}, '${title}', '${description}')`
        const self = this
        this.getResult(ADD_ADD_INFO_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in ADD_ADD_INFO_QUERY: ${ADD_ADD_INFO_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    editAddInfo(conn, req, res) {
        const { id, title, description } = req.body
        const UPDATE_ADD_INFO_QUERY = `UPDATE additionalInfo SET title='${title}', description='${description}' WHERE id=${id}`
        const self = this
        self.getResult(UPDATE_ADD_INFO_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in UPDATE_ADD_INFO_QUERY: ${UPDATE_ADD_INFO_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    removeAddInfo(conn, req, res) {
        const { id } = req.body
        const REMOVE_ADD_INFO_QUERY = `DELETE FROM additionalInfo WHERE id=${id}`
        const self = this
        self.getResult(REMOVE_ADD_INFO_QUERY, (err, rows) => {
            if (err) {
                self.outputToConsole(`Error in REMOVE_ADD_INFO_QUERY: ${REMOVE_ADD_INFO_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    updateCandidate(conn, req, res) {
        const { candidateID, fname, lname, email, phone, status, website } = req.body
        let insertWebsite = `'${website}'`
        if (website === null || website.length === 0)
            insertWebsite = 'NULL'
        const UPDATE_CANDIDATE_QUERY = `UPDATE candidates SET fname='${fname}', lname='${lname}', email='${email}', phone='${phone}', status=${status}, website=${insertWebsite} WHERE id=${candidateID}`
        this.getResult(UPDATE_CANDIDATE_QUERY, (err, rows) => {
            if (err) {
                console.log(`Error in UPDATE_CANDIDATE_QUERY: ${UPDATE_CANDIDATE_QUERY}`)
                res.status(500).send('Error')
            } else {
                res.status(200).send('Success')
            }
        })
    }

    searchCandidates(conn, req, res) {
        const { text } = req.query
        const SEARCH_CANDIDATES_QUERY = this.buildSearchQuery(text)
        conn.query(SEARCH_CANDIDATES_QUERY, function(err, rows) {
            if (err) {
                res.status(500)
                res.send(`Error`)
                this.outputToConsole(`Error in SEARCH_CANDIDATES_QUERY in searchCandidates: ${SEARCH_CANDIDATES_QUERY}`)
            } else {
                res.status(200)
                return res.json({
                    data: rows
                })
            }
        })
    }

    getExcelExport(conn, req, res) {
        const { text } = req.query
        const EXCEL_EXPORT_QUERY = this.buildSearchQuery(text)
        let workbook = new Excel.Workbook()
        workbook.creator = "Lochmueller Group Outreach Tracking Tool"
        workbook.created = new Date()
        workbook.properties.date1904 = true
        workbook.calcProperties.fullCalcOnLoad = true
        workbook.views = [
            {
                x: 0, y: 0, width: 10000, height: 20000,
                firstSheet: 0, activeTab: 1, visibility: 'visible'
            }
        ]
        const worksheet = workbook.addWorksheet('Candidates')
        worksheet.columns = [
            { header: 'Last Name', key: 'lname', width: 16 },
            { header: 'First Name', key: 'fname', width: 16 },
            { header: 'Email', key: 'email', width: 20, outlineLevel: 1 },
            { header: 'Phone', key: 'phone', width: 16 },
            { header: 'Status', key: 'status', width: 10 }
        ]
        conn.query(EXCEL_EXPORT_QUERY, function(err, rows) {
            if (err) {
                console.log(`Error in EXCEL_EXPORT_QUERY: ${EXCEL_EXPORT_QUERY}`)
            } else {
                rows.forEach(x => {
                    worksheet.addRow({
                        lname: x.lname,
                        fname: x.fname,
                        email: x.email,
                        phone: x.phone,
                        status: x.status
                    })
                })
                res.attachment("Report.xlsx")
                workbook.xlsx.write(res)
                .then(function() {
                    res.end()
                })
            }
        })
    }
}

module.exports = CandidatesSQL