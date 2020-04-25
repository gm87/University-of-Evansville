import React from 'react'
import { withAuth } from '@okta/okta-react'

import './css/candidateSearch.css'

class UsersSearch extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            searchText: '',
        }
    }

    handleSearchTextChange = event => { this.setState({ searchText: event.target.value })}

    handleSearchClick = async () => {
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/users/search?text=${this.state.searchText}`
        fetch(url, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await this.props.auth.getAccessToken()}`
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
                    this.props.setUsers(data.data)
                }
            })
    }

    render() {
        return (
            <div>
                <input className="candidateSearchInput" onChange={this.handleSearchTextChange} value={this.state.searchText}/>
                <button className="candidateSearchSubmit" onClick={this.handleSearchClick}>Search</button>
            </div>
        )
    }
}

export default withAuth(UsersSearch)