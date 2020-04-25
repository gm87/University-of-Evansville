import React from 'react'

import { NavLink } from 'react-router-dom'

const CandidateListItem = props => {
    return(
        <tr>
            <td>
                <NavLink to={`/candidates/${props.id}`} >
                    {props.lName}, {props.fName}
                </NavLink>
            </td>
            <td>{props.email && props.email.length > 0 ? props.email : 'None'}</td>
            <td>{props.convertDate(props.dateCreated)}</td>
            <td>{props.status}</td>
        </tr>
    )
}

export default CandidateListItem