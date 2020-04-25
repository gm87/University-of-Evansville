import React from 'react'
import { NavLink } from 'react-router-dom'

import LoginButton from './LoginButton'

import './css/header.css'

function Header () {
    return (
        <div className="Nav">
            <NavLink
                className = "Link"
                exact
                to="/"
            >
                Home
            </NavLink>
            <NavLink
                className = "Link"
                to="/candidates"
            >
                Candidates
            </NavLink>
            <NavLink
                className = "Link"
                to="/admin"
            >
                Admin Panel
            </NavLink>
            <LoginButton />
        </div>
    )
}

export default Header