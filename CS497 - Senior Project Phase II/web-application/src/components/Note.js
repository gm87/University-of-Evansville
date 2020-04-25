import React from 'react'
import { withAuth } from '@okta/okta-react'

function Note(props) {

    const handleDeleteClick = async() => {
        if (window.confirm("This will remove the note from the proposal permanently. Are you sure?"))
        {
            const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/notes/remove`
            const data = {
                id: props.id,
                email: props.userinfo.email
            }
            fetch(url, {
                method: 'POST',
                headers: {
                    'content-type': 'application/json',
                    accept: 'application/json',
                    authorization: `Bearer ${await props.auth.getAccessToken()}`
                },
                body: JSON.stringify(data),
            })
            .then(response => {
                if (response.status === 200) {
                    props.updateNotes()
                } else {
                    return -1
                }
            })
            .catch(err => console.error(err))
        }
    }

    const convertToDate = timestamp => {
        const months = ["", "Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
        let split = timestamp.split('-')
        return `${months[parseInt(split[1])]} ${parseInt(`${split[2][0]}${split[2][1]}`)}, ${split[0]}`
    }

    return(
        <div className="noteLightContainer">
            <div className="noteCreatedContainer">
                <span className="noteCreator">{props.createdByUser}</span>
                <span className="noteCreatedDate">{convertToDate(props.createdDate)}</span>
            </div>
            <div className="noteBtnsContainer">
                <span className="noteDeleteBtn" onClick={handleDeleteClick}><i className="fas fa-trash-alt"></i></span>
            </div>
            <br />
            <div className="noteMessageContainer">
                {props.message}
            </div>
        </div>
    )
}

export default withAuth(Note)