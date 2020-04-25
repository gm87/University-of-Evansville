import React from 'react'
import { NavLink } from 'react-router-dom'

import './css/notFound.css'

function Error404(props) {
    return (
        <div className="pagewrapper">
            <h1 className="notFoundTitle">404 ERROR</h1>
            <div className="errorMsg">The page you were looking for could not be found.</div>
            <div className="homeBtnDiv">
                <NavLink to="/" >
                    <button className="homeBtn">Return Home</button>
                </NavLink>
            </div>
        </div>
    )
}

export default Error404