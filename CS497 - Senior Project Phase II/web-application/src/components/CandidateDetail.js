import React, { useState, useEffect } from 'react'
import { Redirect } from 'react-router-dom'
import { withAuth } from '@okta/okta-react'

import Card from './Card'
import Loading from './Loading'
import Note from './Note'
import NoteForm from './NoteForm'
import GoogleMap from './GoogleMap'

import './css/candidateDetail.css'

function CandidateDetail(props) {

    const [candidateData, setCandidateData] = useState(null)
    const [foundCandidate, setFoundCandidate] = useState(null)
    const [showMenu, setShowMenu] = useState(false)
    const [fname, setfName] = useState(null)
    const [lname, setlName] = useState(null)
    const [tempfName, setTempfName] = useState(null)
    const [templName, setTemplName] = useState(null)
    const [email, setEmail] = useState(null)
    const [phone, setPhone] = useState(null)
    const [website, setWebsite] = useState(null)
    const [noteData, setNoteData] = useState(null)
    const [eduData, setEduData] = useState(null)
    const [workExpData, setWorkExpData] = useState(null)
    const [addInfoData, setAddInfoData] = useState(null)
    const [editName, setEditName] = useState(false)
    const [status, setStatus] = useState(null)
    const [addAddInfo, setAddAddInfo] = useState(false)
    const [addWorkData, setAddWorkData] = useState(false)
    const [addEduData, setAddEduData] = useState(false)

    const getCandidateData = _ => {
        for (let i=0; i<props.candidates.length; i++) {
            if (props.candidates[i].id === parseInt(props.match.params.id)) {
                setCandidateData(props.candidates[i])
                setFoundCandidate(true)
                break
            } else if (i === props.candidates.length - 1) {
                setFoundCandidate(false)
            }
        }
    }

    ////////////////
    /// API REQS ///
    ////////////////

    const getNoteData = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/notes/candidate?id=${props.match.params.id}`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            }
        })
          .then(response => response.json())
          .then(response => setNoteData(response.data))
          .catch(err => console.log(err))
    }

    const getEduData = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/eduinfo?id=${props.match.params.id}`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            }
        })
        .then(response => response.json())
        .then(response => setEduData(response.data))
        .catch(err => console.log(err))
    }

    const getWorkExpData = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/workinfo?id=${props.match.params.id}`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            }
        })
        .then(response => response.json())
        .then(response => setWorkExpData(response.data))
        .catch(err => console.log(err))
    }

    const getAddInfoData = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/addinfo?id=${props.match.params.id}`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            }
        })
        .then(response => response.json())
        .then(response => setAddInfoData(response.data))
        .catch(err => console.log(err))
    }

    const updateCandidateInfo = async() => {
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/update`
        const data = {
            fname: fname,
            lname: lname,
            email: email,
            phone: phone,
            website: website,
            status: status,
            candidateID: props.match.params.id
        }
        fetch(url, {
            method: "POST",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            },
            body: JSON.stringify(data)
        })
        .catch(err => console.log(err))
    }

    ////////////////
    /// HANDLERS ///
    ////////////////
    const handleMenuBtnClick = _ => { setShowMenu(!showMenu) }

    const handleRenameClick = _ => { setEditName(!editName) }

    const handleAddAddDataClick = _ => {setAddAddInfo(!addAddInfo)}

    const handleAddWorkDataClick = _ => {setAddWorkData(!addWorkData)}

    const handleAddEduDataClick = _ => {setAddEduData(!addEduData)}

    const saveNewName = _ => {
        setfName(tempfName)
        setlName(templName)
        setEditName(!editName)
    }

    const handleRenameCancelClick = _ => {
        setTempfName(candidateData.fname)
        setTemplName(candidateData.lname)
        setEditName(!editName)
    }

    /////////////////
    /// RENDERERS ///
    /////////////////
    const renderNote = ({ id, fname, lname, message, createdDate }) => {
        return(
            <Note
                key={id}
                id={id} 
                createdByUser={`${fname} ${lname}`}
                createdDate={createdDate}
                message={message}
                users={props.users}
                userinfo={props.userinfo}
                updateNotes={getNoteData}
            />
        )
    }

    const renderEduCard = ({ eduID, institutionName, beginDate, endDate, summary, fieldOfStudy, degreeType }) => {
        return (
            <Card
                eduInfo
                key={eduID}
                id={eduID}
                institutionName={institutionName}
                beginDate={beginDate}
                endDate={endDate}
                summary={summary}
                fieldOfStudy={fieldOfStudy}
                degreeType={degreeType}
                updateEduData={getEduData}
            />
        )
    }

    const renderWorkExpCard = ({ id, name, title, beginDate, endDate, summary }) => {
        return (
            <Card
                workExp
                key={id}
                id={id}
                workplace={name}
                title={title}
                beginDate={beginDate}
                endDate={endDate}
                summary={summary}
                updateWorkData={getWorkExpData}
            />
        )
    }

    const renderAddInfoCard = ({ id, title, description }) => {
        return (
            <Card
                addInfo
                key={id}
                id={id}
                title={title}
                summary={description}
                updateAddData={getAddInfoData}
            />
        )
    }

    // get candidate data on mount
    useEffect(() => {
        if (!candidateData && props.candidates)
            getCandidateData()
        if (!noteData) {
            getNoteData()
        }
        if (!eduData) {
            getEduData()
        }
        if (!addInfoData) {
            getAddInfoData()
        }
        if (!workExpData) {
            getWorkExpData()
        }
    })

    // update candidate data fields when candidate data changes
    useEffect(() => {
        if (candidateData !== null) {
            setfName(candidateData.fname)
            setlName(candidateData.lname)
            setTempfName(candidateData.fname)
            setTemplName(candidateData.lname)
            setEmail(candidateData.email)
            setPhone(candidateData.phone)
            setWebsite(candidateData.website ? candidateData.website : '')
            setStatus(candidateData.statusID)
        }
    }, [candidateData])

    useEffect(() => {
        if (candidateData !== null && (
            fname !== candidateData.fname ||
            lname !== candidateData.lname ||
            email !== candidateData.email ||
            phone !== candidateData.phone ||
            website !== candidateData.website ||
            status !== candidateData.statusID
        )) {
            updateCandidateInfo()
        }
    }, [fname, lname, email, phone, website, status])

    useEffect(() => {
        if (props.candidates) 
            getCandidateData()
    }, [props.candidates])

    if (foundCandidate === null || (foundCandidate === true && (addInfoData === null || workExpData === null || eduData === null))) {
        return(<Loading />)
    } else if (foundCandidate === false) {
        return (<Redirect to="/*" />)
    }

    return (
        <div className="pagewrapper">
        <div className="candidateDetailContainer">
            <div className="candidateDetailHeaderContainer">
                <div className="candidateName">
                    {
                        !editName ?
                        `${fname} ${lname}` :
                        <div className="candidateDetailNameInput">
                        <div>
                            <input className="candidateDetailfNameInput" value={tempfName} required onChange={e => setTempfName(e.target.value)} />
                            <input className="candidateDetaillNameInput" required value={templName} onChange={e => setTemplName(e.target.value)} />
                            <span className="cancelBtn" onClick={handleRenameCancelClick}><i className="fas fa-ban"></i></span>
                            <span className="cardSubmit" onClick={saveNewName} type="submit"><i className="fas fa-check"></i></span>
                        </div>
                        </div>
                    }
                    
                </div>
                <br />
                <span onClick={handleMenuBtnClick} className="menuBtnContainer">
                    <span className="menuBtn">MENU</span>
                    {
                        showMenu &&
                        <div className="editBtnDropdown">
                            <span onClick={handleRenameClick}>Rename</span>
                        </div>
                    }
                </span>
            </div>
            <div className="sectionContainer">
                <div className="header">Contact Information</div>
                <div className="sectionBody">
                    <div className="subHeader">Email</div>
                    <Card email value={email} save={setEmail} />
                    <div className="subHeader">Phone</div>
                    <Card phone value={phone} save={setPhone} />
                    <div className="subHeader">Address</div>
                    <Card 
                        address 
                        address1={candidateData.address1} 
                        address2={candidateData.address2} 
                        city={candidateData.city} 
                        state={candidateData.stateID}  
                        postal={candidateData.postal}
                        states={props.states}
                        candidateID={props.match.params.id}
                        addressID={candidateData.addressID}
                        updateCandidates={props.updateCandidates}
                    />
                    <div className="subHeader">Website</div>
                    <Card website value={website} save={setWebsite} />
                </div>
            </div>
            <div className="sectionContainer">
                <div className="header">Education Information { eduData.length > 0 && !addEduData && <span className="newObjBtn" onClick={handleAddEduDataClick}><i className="fas fa-plus" /></span> } </div>
                <div className="sectionBody">
                    {
                        addEduData &&
                        <Card
                            new
                            eduInfo
                            candidateID={props.match.params.id}
                            handleCancelClick={handleAddEduDataClick}
                            updateEduData={getEduData}
                        />
                    }
                    {
                        eduData.length === 0 ?
                        <Card noEduData candidateID={props.match.params.id} updateEduData={getEduData} /> :
                        eduData.map(renderEduCard)
                    }
                </div>
            </div>
            <div className="sectionContainer">
                <div className="header">Work Experience { workExpData.length > 0 && !addWorkData && <span className="newObjBtn" onClick={handleAddWorkDataClick}><i className="fas fa-plus" /></span> } </div>
                <div className="sectionBody">
                    {
                        addWorkData &&
                        <Card
                            new
                            workExp
                            candidateID={props.match.params.id}
                            handleCancelClick={handleAddWorkDataClick}
                            updateWorkData={getWorkExpData}
                        />
                    }
                    {
                        workExpData.length === 0 ?
                        <Card noWorkExperience candidateID={props.match.params.id} updateWorkData={getWorkExpData} /> :
                        workExpData.map(renderWorkExpCard)
                    }
                </div>
            </div>
            <div className="sectionContainer">
                <div className="header">Additional Information { addInfoData.length > 0 && !addAddInfo && <span className="newObjBtn" onClick={handleAddAddDataClick}><i className="fas fa-plus" /></span> } </div>
                <div className="sectionBody">
                    {
                        addAddInfo &&
                        <Card
                            new
                            addInfo
                            candidateID={props.match.params.id}
                            handleCancelClick={handleAddAddDataClick}
                            updateAddData={getAddInfoData}
                        />
                    }
                    {
                        addInfoData.length === 0 ?
                        <Card noAddInfo candidateID={props.match.params.id} updateAddData={getAddInfoData} /> :
                        addInfoData.map(renderAddInfoCard)
                    }
                </div>
            </div>
            <div className="sectionContainer">
                <div className="header">Connected Information</div>
                <div className="subHeader">Location</div>
                <div className="sectionBody">
                    <GoogleMap centerLat={candidateData.sourceLocationLat} centerLng={candidateData.sourceLocationLong} />
                </div>
                <div className="subHeader">Added By</div>
                <div className="sectionBody">
                    {candidateData.connectedWithlName}, {candidateData.connectedWithfName}
                </div>
            </div>
            <div className="sectionContainer">
                <div className="header">Notes</div>
                <div className="sectionBody">
                    {noteData && noteData.map(renderNote)}
                    <NoteForm id={candidateData.id} updateNotes={getNoteData} userinfo={props.userinfo} />
                </div>
            </div>
            <div className="sectionSpacer"></div>
        </div>
        </div>
    )
}

export default withAuth(CandidateDetail)