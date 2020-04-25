import React from 'react'
import { NavLink } from 'react-router-dom'

function AdminPanel() {
    return (
        <div className="pagewrapper">
            <h1 className="pageHeaderTitle">Admin Panel</h1>
            <NavLink to="/admin/users">Users</NavLink>
        </div>
    )
}

export default AdminPanel