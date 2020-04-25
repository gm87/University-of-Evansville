import React from 'react'

import UsersTable from './UsersTable'
import UsersSearch from './UsersSearch'

class UsersPage extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            users: props.users
        }
    }

    setUsers = users => { this.setState({ users: users }) }

    render() {
        return (
            <div className="pagewrapper">
                <h1 className="pageHeaderTitle">Users</h1>
                <UsersSearch setUsers={this.setUsers} />
                <UsersTable users={this.state.users} />
            </div>
        )
    }
}

export default UsersPage