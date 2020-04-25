import React from 'react'
import { Route, Switch } from 'react-router-dom'
import { SecureRoute, ImplicitCallback, withAuth } from '@okta/okta-react'

import Header from './Header'
import Home from './Home'
import AdminPanel from './AdminPanel'
import Candidates from './Candidates'
import UsersPage from './UsersPage'
import CandidateDetail from './CandidateDetail'
import UserDetail from './UserDetail'
import Error404 from './Error404'

class App extends React.Component {
    constructor() {
        super()
        this.state = {
            candidates: null,
            states: null,
            users: null,
            userinfo: null,
        }
    }

    componentDidMount = async () => {
        this.getAccessToken()
        this.checkAuthentication()
        this.updateCandidates()
        this.getStates()
        this.updateUsers()
    }

    getAccessToken = async (recursionCount) => {
        if (!recursionCount) {
            recursionCount = 0
        }
        await this.props.auth.getAccessToken()
        .then(token => {
            if (token === undefined && recursionCount < 5) {
                this.getAccessToken(recursionCount++)
            } else if (recursionCount >= 5) {
                console.log(`Tried to get access token too many times`)
            } else {
                if (!this.state.candidates)
                    this.updateCandidates()
                if (!this.state.states)
                    this.getStates()
                if (!this.state.users)
                    this.updateUsers()
            }
        })
        .catch(err => console.log(`error: ${err}`))
    }

    componentDidUpdate() {
        if (this.state.userinfo == null) {
            this.checkAuthentication()
        }
    }

    checkAuthentication = async () => {
        const authenticated = await this.props.auth.isAuthenticated();
        if (authenticated && !this.state.userinfo) {
          const userinfo = await this.props.auth.getUser();
          this.setState({ userinfo });
        }
    }

    convertDate = timestamp => {
        let day
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
        const month = months[parseInt(timestamp.substring(5, 7)) - 1]
        if (parseInt(timestamp.substring(8, 10)) < 10) {
            day = timestamp.substring(9, 10)
        } else {
            day = timestamp.substring(8, 10)
        }
        return(`${month} ${day}, ${timestamp.substring(0, 4)}`)
    }

    updateCandidates = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/candidates`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await this.props.auth.getAccessToken()}`
            }
        })
            .then(response => response.json())
            .then(response => this.setState({ candidates: response.data }))
            .catch(err => console.log(err))
    }

    updateUsers = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/users`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await this.props.auth.getAccessToken()}`
            }
        })
        .then(response => response.json())
        .then(response => this.setState({ users: response.data }))
        .catch(err => console.log(err))
    }

    getStates = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/states`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await this.props.auth.getAccessToken()}`
            }
        })
            .then(response => response.json())
            .then(response => this.setState({ states: response.data }))
            .catch(err => console.log(err))
    }

    render() {
        return(
            <div>
                <Header />
                <Switch>
                    <Route
                        path="/implicit/callback"
                        component = {ImplicitCallback}
                    />
                    <SecureRoute
                        exact
                        path="/"
                        render = { _ => (
                            <Home userinfo={this.state.userinfo} />
                        )}
                    />
                    <SecureRoute
                        exact
                        path="/candidates"
                        render = { _ => (
                            <Candidates 
                                key={this.state.candidates}
                                candidates={this.state.candidates}
                                convertDate={this.convertDate}
                            />
                        )}
                    />
                    <SecureRoute
                        exact
                        path="/candidates/:id"
                        render={(navProps) => (
                            <CandidateDetail
                                candidates={this.state.candidates}
                                convertDate={this.convertDate}
                                updateCandidates={this.updateCandidates}
                                states={this.state.states}
                                userinfo={this.state.userinfo}
                                {...navProps}
                            />
                        )}
                    />
                    <SecureRoute
                        exact
                        path="/admin"
                        render = { _ => (
                            <AdminPanel />
                        )}
                    />
                    <SecureRoute
                        exact
                        path="/admin/users"
                        render = { _ => (
                            <UsersPage 
                                key={this.state.users}
                                users={this.state.users} 
                            />
                        )}
                    />
                    <SecureRoute
                        exact
                        path="/admin/users/:id"
                        render={(navProps) => (
                            <UserDetail
                                {...navProps}
                            />
                        )}
                    />
                    <Route
                        path="*"
                        render={_ => (
                            <Error404 />
                        )}
                    />
                </Switch>
            </div>
        )
    }
}

export default withAuth(App)