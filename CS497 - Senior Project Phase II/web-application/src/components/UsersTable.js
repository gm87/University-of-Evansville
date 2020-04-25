import React from 'react'

import { NavLink } from 'react-router-dom'

import './css/candidateTable.css'

function renderUser ({ id, fName, lName, email, isAdmin }) {
    return(<tr key={id}><td><NavLink to={`/admin/users/${id}`}>{`${lName}, ${fName}`}</NavLink></td><td>{email}</td></tr>)
} 

function UsersTable(props) {
    const style = { textAlign : "center" }
    return(
        props.users && props.users.length > 0 ?
        <table className="candidatesTable">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
                {props.users.map(renderUser)}
            </tbody>
        </table>
        : <div style={style}>No results found!</div>
    )
}

export default UsersTable