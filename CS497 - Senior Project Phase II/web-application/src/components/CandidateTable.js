import React from 'react'

import CandidateListItem from './CandidateListItem'

import './css/candidateTable.css'

function CandidateTable(props) {
    const style = { textAlign : "center" }
    return(
        props.candidates && props.candidates.length > 0 ?
        <table className="candidatesTable">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Date Added</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                {props.candidates.map(({ id, fname, lname, email, dateCreated, status }) => <CandidateListItem key={id} id={id} fName={fname} lName={lname} email={email} dateCreated={dateCreated} status={status} convertDate={props.convertDate} />)}
            </tbody>
        </table>
        : <div style={style}>No results found!</div>
    )
}

export default CandidateTable