import React from 'react'

function Home(props) {
    return (
        <div className="pagewrapper">
            <div className="pageHeaderTitle">
                Outreach Tracking Tool
            </div>
            <div className="homeLogo">
            <svg width="400px" height="100px" className="homeImage1" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlnsXlink="http://www.w3.org/1999/xlink">
                <image href="http://employee.lochgroup.com/wp-content/uploads/employee/sites/2/logos/ThreeColorOfficial.png" x="0" y="0" height="100px" width="400px"/>
            </svg>
            <div className="homeContent1">
                Welcome back, {props.userinfo && props.userinfo.given_name} {props.userinfo && props.userinfo.family_name}
            </div>
            </div>
        </div>
    )
}

export default Home