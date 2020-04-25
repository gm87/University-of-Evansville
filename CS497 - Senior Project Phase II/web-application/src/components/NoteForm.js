import React, { useState } from 'react'
import { withAuth } from '@okta/okta-react'

function NoteForm(props) {
    const [message, setMessage] = useState('')

    const handleSubmit = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/notes/add`
        const data = {
            id: props.id,
            message: message,
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
                setMessage('')
            } else {
                return -1
            }
        })
        .catch(err => console.error(err))
    }

    return (
        <div>
            <form onSubmit={handleSubmit}>
                <input className="noteInput" required maxLength="255" type="text" onChange={e => setMessage(e.target.value)} placeholder="Enter your message..." value={message} />
                <input type="submit" className="submitNote" />
            </form>
        </div>
    )
}

export default withAuth(NoteForm)