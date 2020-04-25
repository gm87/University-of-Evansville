import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/App';
import { BrowserRouter as Router } from 'react-router-dom'
import { Security } from '@okta/okta-react'
import * as serviceWorker from './serviceWorker';
import './index.css'

const dotenv = require('dotenv')
dotenv.config()

const oktaConfig = {
    issuer: `${process.env.REACT_APP_OKTA_ORG_URL}/oauth2/default`,
    redirect_uri: `${window.location.origin}/implicit/callback`,
    client_id: process.env.REACT_APP_OKTA_CLIENT_ID,
}

ReactDOM.render(
<Router>
    <Security {...oktaConfig}>
        <App />
    </Security>
</Router>, 
document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();