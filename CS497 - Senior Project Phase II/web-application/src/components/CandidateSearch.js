import React from 'react'
import { withAuth } from '@okta/okta-react'

import './css/candidateSearch.css'

function CandidateSearch(props) {

    const handleKeyPress = event => { if (event.key === "Enter") handleSearchClick() }

    const handleSearchClick = async () => {
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/search?text=${props.searchText}`
        fetch(url , {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            }
        })
            .then(response => {
                if (response.status === 200) {
                    return response.json()
                } else {
                    return -1
                }
            })
            .then(data => {
                if (data === -1) {
                    console.log(`Something went wrong!`)
                } else {
                    props.setCandidates(data.data)
                }
            })
    }

    const handleSearchTextChange = e => {
        props.searchTextChange(e.target.value)
    }

    return (
        <div>
            <input className="candidateSearchInput" onChange={handleSearchTextChange} onKeyPress={handleKeyPress} value={props.searchText}/>
            <button className="candidateSearchSubmit" onClick={handleSearchClick}>Search</button>
        </div>
    )
}

export default withAuth(CandidateSearch)