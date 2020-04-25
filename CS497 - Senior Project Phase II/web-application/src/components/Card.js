import React, { useState, useEffect } from 'react'
import { withAuth } from '@okta/okta-react'

import './css/card.css'

function Card(props) {

    const [value, setValue] = useState(props.value || '')
    const [expandedView, setExpandedView] = useState(props.new ? true : false)
    const [editing, setEditing] = useState(props.new ? true : false)

    // address card states
    const [address1, setAddress1] = useState(props.address1 || '')
    const [address2, setAddress2] = useState(props.address2 || '')
    const [city, setCity] = useState(props.city || '')
    const [state, setState] = useState(props.state || '')
    const [postal, setPostal] = useState(props.postal || '')
    const [cities, setCities] = useState(null)

    // addInfo, eduInfo, workExp shared states
    const [summary, setSummary] = useState(props.summary && props.summary !== "undefined" ? props.summary : '')

    // eduInfo, workExp shared states
    const [beginDate, setBeginDate] = useState(props.beginDate ? props.beginDate.substring(0, 7) : '')
    const [endDate, setEndDate] = useState(props.endDate ? props.endDate.substring(0, 7) : '')

    // workExp, addInfo shared states
    const [title, setTitle] = useState(props.title || '')

    // eduInfo card state
    const [institution, setInstitution] = useState(props.institutionName || '')
    const [fieldOfStudy, setFieldOfStudy] = useState(props.fieldOfStudy || '')
    const [degreeType, setDegreeType] = useState(props.degreeType || '')

    // workExp card state
    const [workplace, setWorkpalce] = useState(props.workplace)

    const convertToMonthYear = string => {
        const months = ["", "January", "February", "March", "April", "May", "June", 
                        "July", "August", "September", "October", "November", "Dececmber"]
        const year = string.substring(0, 4)
        const month = parseInt(string.substring(5, 7))
        if (parseInt(year) === 0) { return `Present` }
        return `${months[month]} ${year}`
    }

    const getElementById = (id, options) => {
        let val = null
        options.forEach(x => {
            if (x.id === parseInt(id))
                val = x
        })
        return val
    }

    const handleEditClick = _ => { 
        setEditing(!editing) 
        setValue(props.value)
        setSummary(props.summary)
        if (props.eduInfo) {
            setBeginDate(props.beginDate)
            setEndDate(props.endDate)
            setInstitution(props.institutionName)
            setFieldOfStudy(props.fieldOfStudy)
            setDegreeType(props.degreeType)
        } else if (props.workExp) {
            setWorkpalce(props.workplace)
            setBeginDate(props.beginDate)
            setEndDate(props.endDate)
            setTitle(props.title)
        } else if (props.addInfo) {
            setTitle(props.title)
        } else if (props.address) {
            setAddress1(props.address1)
            setAddress2(props.address2)
            setCity(props.city)
            setState(props.state)
            setPostal(props.postal)
            setCities(null)
        }
    }

    const handleExpandClick = _ => {
        setExpandedView(!expandedView)
    }

    const handleSaveClick = _ => {
        props.save(value)
        setEditing(!editing)
    }

    const getCities = async () => {
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/cities?stateID=${state}`, {
            method: "GET",
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            }
        })
            .then(response => response.json())
            .then(response => setCities(response.data))
            .catch(err => console.log(err))
    }

    const saveNewAddress = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/address/add`
        const data = {
            address1: address1,
            address2: address2,
            city: city,
            state: state,
            postal: postal,
            candidateID: props.candidateID
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
        .then(response => {
            if(response.status === 200) {
                setEditing(!editing)
                props.updateCandidates()
            } else {
                console.log('something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const saveEditedAddress = async (e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/address/edit`
        const data = {
            address1: address1,
            address2: address2,
            city: city,
            state: state,
            postal: postal,
            addressID: props.addressID
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
            .then(response => {
                if (response.status === 200) {
                    setEditing(!editing)
                } else {
                    console.log('Something went wrong')
                }
            })
            .catch(err => console.log(err))
    }

    const saveNewEduInfo = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/eduinfo/add`
        const data = {
            candidateId: props.candidateID,
            degree: degreeType,
            field: fieldOfStudy,
            institution: institution,
            beginDate: beginDate,
            endDate: endDate,
            summary: summary
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
        .then(response => {
            if (response.status === 200) {
                props.updateEduData()
                if (props.new)
                    props.handleCancelClick()
            } else {
                console.log('Something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const saveUpdatedEdu = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/eduinfo/edit`
        const data = {
            id: props.id,
            degree: degreeType,
            field: fieldOfStudy,
            institution: institution,
            beginDate: beginDate,
            endDate: endDate,
            summary: summary
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
        .then(response => {
            if (response.status === 200) {
                props.updateEduData()
                setEditing(!editing)
            } else {
                console.log('Something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const saveNewWorkExpInfo = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/workinfo/add`
        const data = {
            candidateId: props.candidateID,
            workplace: workplace,
            title: title,
            beginDate: beginDate,
            endDate: endDate,
            summary: summary
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
        .then(response => {
            if (response.status === 200) {
                props.updateWorkData()
                if (props.new)
                    props.handleCancelClick()
            } else {
                console.log('Something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const saveUpdatedWork = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/workinfo/edit`
        const data = {
            id: props.id,
            workplace: workplace,
            title: title,
            beginDate: beginDate,
            endDate: endDate,
            summary: summary
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
        .then(response => {
            if (response.status === 200) {
                props.updateWorkData()
                setEditing(!editing)
            } else {
                console.log('Something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const saveNewAddInfo = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/addinfo/add`
        const data = {
            candidateId: props.candidateID,
            title: title,
            description: summary
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
        .then(response => {
            if (response.status === 200) {
                props.updateAddData()
                if (props.new)
                    props.handleCancelClick()
            } else {
                console.log('Something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const saveUpdatedAdd = async(e) => {
        e.preventDefault()
        const url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/addinfo/edit`
        const data = {
            id: props.id,
            title: title,
            description: summary
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
        .then(response => {
            if (response.status === 200) {
                props.updateAddData()
                setEditing(!editing)
            } else {
                console.log('Something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const handleDeleteClick = async(e) => {
        let url = ''
        const data = {
            id: props.id
        }
        if (props.eduInfo) {
            url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/eduinfo/remove`
        } else if (props.addInfo) {
            url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/addinfo/remove`
        } else if (props.workExp) {
            url = `${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/workinfo/remove`
        } else {
            console.log('Something went wrong')
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
        .then(response => {
            if (response.status === 200) {
                if (props.eduInfo) {
                    props.updateEduData()
                } else if (props.addInfo) {
                    props.updateAddData()
                } else if (props.workExp) {
                    props.updateWorkData()
                }
            } else {
                console.log('Something went wrong')
            }
        })
        .catch(err => console.log(err))
    }

    const handlePhoneChange = e => {
        console.log(`value: ${props.value}`)
        let phone = e.target.value
        if ((phone.length === 3 && value.length === 2) || (phone.length === 7 && value.length === 6)) {
            phone += '-'
        } else if ((phone.length === 8 && value.length === 9) || (phone.length === 4 && value.length === 5)) {
            phone = phone.substring(0, phone.length-1)
        }
        if ((phone.length !== 4 && phone.length !== 8) && !isNaN(phone[phone.length-1])) {
            setValue(phone)
        } else if (!isNaN(phone[phone.length-2])) {
            setValue(phone)
        } else if (phone.length === 0) {
            setValue('')
        }
    }

    const renderState = ({ id, name }) => {
        return(<option key={id} value={id}>{name}</option>)
    }

    const renderCity = ({ id, name }) => {
        return(<option key={id} value={id}>{name}</option>)
    }

    useEffect(() => {
        setValue(props.value)
    }, [props.value])

    useEffect(() => {
        if (state) {
            getCities()
        }
    }, [state])

    useEffect(() => {
        if (!cities && state) {
            getCities()
        }
    })

    if (props.email || props.phone || props.website) {
        if (value === null || value === undefined || value.length === 0) {
            return (
                !editing ?
                <div className="errorCardContainer">
                    No {props.email && "Email"}{props.phone && "Phone"}{props.website && "Website"} Found!
                    <span className="newBtn" onClick={handleEditClick}><i className="fas fa-pencil-alt"></i></span>
                </div>
                :
                <div className="errorCardContainer">
                <div className="btnsContainer"><div><span onClick={handleSaveClick} className="checkBtn"><i className="fas fa-check"></i></span><span className="cancelBtn" onClick={handleEditClick}><i className="fas fa-ban"></i></span></div></div>
                <input className="errorCardInput" value={value} onChange={props.phone ? handlePhoneChange : e => setValue(e.target.value)} />
                </div>
            )
        }
        return (
            !editing ?
            <div className="cardContainer">
                {value}
                <span className="btnsContainer">
                    {props.email && <span className="emailBtn"><a href={`mailto:${value}`}><i className="fas fa-envelope" /></a></span> }
                    {props.website && <span className="browserBtn"><a href={value.includes('https://') ? value : `https://${value}`}><i className="fas fa-window-restore" /></a></span> }
                    <span className="editBtn" onClick={handleEditClick}><i className="far fa-edit"></i></span>
                </span>
            </div>
            :
            <div className="cardContainer">
            <div className="btnsContainer"><div><span onClick={handleSaveClick} className="checkBtn"><i className="fas fa-check"></i></span><span className="cancelBtn" onClick={handleEditClick}><i className="fas fa-ban"></i></span></div></div>
            <input className="cardInput" value={value} maxLength={props.phone ? 12 : 45} onChange={props.phone ? handlePhoneChange : e => setValue(e.target.value)} />
            </div>
        )
    }

    if (props.eduInfo) {
        const degrees = ["Associate's", "Bachelor's", "Master's", "PhD"]
        if (!expandedView) { // compact view
            return(
            <div className="cardContainer">
                {degrees[degreeType]} in {fieldOfStudy}
                <span className="editBtn" onClick={handleExpandClick}><i className="fas fa-chevron-down"></i></span>
            </div>
            )
        } else if (!editing) { // expanded view
            return (
                <div className="cardContainer">
                    <span className="cardBtns">
                        <span className="deleteBtn" onClick={handleDeleteClick}><i className="fas fa-trash-alt"></i></span>
                        <span className="editBtn" onClick={handleEditClick}><i className="far fa-edit"></i></span>
                    </span>
                    <div className="cardHeader">Degree</div>
                    <div className="cardHeaderContent">{degrees[degreeType]}</div>
                    <div className="cardHeader">Field of Study</div>
                    <div className="cardHeaderContent">{fieldOfStudy}</div>
                    <div className="cardHeader">Institution</div>
                    <div className="cardHeaderContent">{institution}</div>
                    <div className="cardHeader">Begin Date</div>
                    <div className="cardHeaderContent">{convertToMonthYear(beginDate)}</div>
                    <div className="cardHeader">End Date</div>
                    <div className="cardHeaderContent">{convertToMonthYear(endDate)}</div>
                    <div className="cardHeader">Summary</div>
                    <div className="cardHeaderContent">{summary}</div>
                    <div className="unexpandBtn" onClick={handleExpandClick}><i className="fas fa-chevron-up"></i></div>
                </div>
            )
        } else if (editing) { // editing view
            return (
            <form className="cardContainer" autoComplete="off">
                <span className="cardBtns">
                    <button className="cancelBtn" onClick={props.new ? props.handleCancelClick : handleEditClick}><i className="fas fa-ban"></i></button>
                    <button className="cardSubmit" type="submit" onClick={props.new ? saveNewEduInfo : saveUpdatedEdu}><i className="fas fa-check"></i></button>
                </span>
                <br />
                <div className="cardHeader">Degree</div>
                <select required value={degreeType} onChange={e => setDegreeType(e.target.value)} className="cardInput">
                    <option disabled hidden value=''></option>
                    <option value={0}>Associate's</option>
                    <option value={1}>Bachelor's</option>
                    <option value={2}>Master's</option>
                    <option value={3}>Doctorate</option>
                </select>
                <div className="cardHeader">Field of Study</div>
                <input required className="cardInput" value={fieldOfStudy} onChange={e => setFieldOfStudy(e.target.value)} />
                <div className="cardHeader">Institution</div>
                <input required className="cardInput" onChange={e => setInstitution(e.target.value)} value={institution} />
                <div className="cardHeader">Begin Date</div>
                <input required type="month" className="cardMonthInput" onChange={e => setBeginDate(e.target.value)} value={beginDate.substring(0, 7)} />
                <div className="cardHeader">End Date</div>
                <input required type="month" className="cardMonthInput" onChange={e => setEndDate(e.target.value)} value={endDate.substring(0, 7)} />
                <div className="cardHeader">Summary</div>
                <textarea className="cardInput" value={summary} onChange={e => setSummary(e.target.value)} />
            </form>
            )
        }
    }

    if (props.workExp) {
        if (!expandedView) { // compact view
            return (
                <div className="cardContainer">
                    {title} at {workplace}
                    <span className="editBtn" onClick={handleExpandClick}><i className="fas fa-chevron-down"></i></span>
                </div>
            )
        } else if (!editing) { // expanded view
            return (
                <div className="cardContainer">
                    <span className="cardBtns">
                        <span className="deleteBtn" onClick={handleDeleteClick}><i className="fas fa-trash-alt"></i></span>
                        <span className="editBtn" onClick={handleEditClick}><i className="far fa-edit"></i></span>
                    </span>
                    <div className="cardHeader">Workplace</div>
                    <div className="cardHeaderContent">{workplace}</div>
                    <div className="cardHeader">Title</div>
                    <div className="cardHeaderContent">{title}</div>
                    <div className="cardHeader">Begin Date</div>
                    <div className="cardHeaderContent">{convertToMonthYear(beginDate)}</div>
                    <div className="cardHeader">End Date</div>
                    <div className="cardHeaderContent">{convertToMonthYear(endDate)}</div>
                    <div className="cardHeader">Summary</div>
                    <div className="cardHeaderContent">{summary}</div>
                    <div className="unexpandBtn" onClick={handleExpandClick}><i className="fas fa-chevron-up"></i></div>
                </div>
            )
        } else if (editing) { // editing view
            return (
                <form className="cardContainer" autoComplete="off">
                    <span className="cardBtns">
                        <button className="cancelBtn" onClick={props.new ? props.handleCancelClick : handleEditClick}><i className="fas fa-ban"></i></button>
                        <button className="cardSubmit" type="submit" onClick={props.new ? saveNewWorkExpInfo : saveUpdatedWork}><i className="fas fa-check"></i></button>
                    </span>
                    <br />
                    <div className="cardHeader">Workplace</div>
                    <input required className="cardInput" onChange={e => setWorkpalce(e.target.value)} value={workplace} />
                    <div className="cardHeader">Title</div>
                    <input required className="cardInput" onChange={e => setTitle(e.target.value)} value={title} />
                    <div className="cardHeader">Begin Date</div>
                    <input required type="month" className="cardMonthInput" onChange={e => setBeginDate(e.target.value)} value={beginDate.substring(0, 7)} />
                    <div className="cardHeader">End Date</div>
                    <input required type="month" className="cardMonthInput" onChange={e => setEndDate(e.target.value)} value={endDate.substring(0, 7)} />
                    <div className="cardHeader">Summary</div>
                    <textarea required className="cardInput" value={summary} onChange={e => setSummary(e.target.value)} />
                </form>
            )
        }
    }

    if (props.addInfo) {
        if (!expandedView) { // compact view
            return (
                <div className="cardContainer">
                    {title}
                    <span className="editBtn" onClick={handleExpandClick}><i className="fas fa-chevron-down"></i></span>
                </div>
            )
        } else if (!editing) { // expanded view
            return (
                <div className="cardContainer">
                    <span className="cardBtns">
                        <span className="deleteBtn" onClick={handleDeleteClick}><i className="fas fa-trash-alt"></i></span>
                        <span className="editBtn" onClick={handleEditClick}><i className="far fa-edit"></i></span>
                    </span>
                    <div className="cardHeader">Title</div>
                    <div className="cardHeaderContent">{title}</div>
                    <div className="cardHeader">Description</div>
                    <div className="cardHeaderContent">{summary}</div>
                    <div className="unexpandBtn" onClick={handleExpandClick}><i className="fas fa-chevron-up"></i></div>
                </div>
            )
        } else if (editing) {
            return (
                <form className="cardContainer" autoComplete="off">
                    <span className="cardBtns">
                        <button className="cancelBtn" onClick={props.new ? props.handleCancelClick : handleEditClick}><i className="fas fa-ban"></i></button>
                        <button className="cardSubmit" type="submit" onClick={props.new ? saveNewAddInfo : saveUpdatedAdd}><i className="fas fa-check"></i></button>
                    </span>
                    <br />
                    <div className="cardHeader">Title</div>
                    <input required className="cardInput" onChange={e => setTitle(e.target.value)} value={title} />
                    <div className="cardHeader">Summary</div>
                    <textarea required className="cardInput" value={summary} onChange={e => setSummary(e.target.value)} />
                </form>
            )
        }
    }

    if (props.noEduData) {
        return (
            !editing ?
            <div className="errorCardContainer">
                No Education Information Found!
                <span className="newBtn" onClick={handleEditClick}><i className="fas fa-pencil-alt"></i></span>
            </div>
            :
            <form className="cardContainer" autoComplete="off">
                <span className="cardBtns">
                    <button className="cancelBtn" onClick={handleEditClick}><i className="fas fa-ban"></i></button>
                    <button className="cardSubmit" type="submit" onClick={saveNewEduInfo}><i className="fas fa-check"></i></button>
                </span>
                <br />
                <div className="cardHeader">Degree</div>
                <select required value={degreeType} onChange={e => setDegreeType(e.target.value)} className="cardInput">
                    <option disabled hidden value=''></option>
                    <option value={0}>Associate's</option>
                    <option value={1}>Bachelor's</option>
                    <option value={2}>Master's</option>
                    <option value={3}>Doctorate</option>
                </select>
                <div className="cardHeader">Field of Study</div>
                <input required className="cardInput" value={fieldOfStudy} onChange={e => setFieldOfStudy(e.target.value)} />
                <div className="cardHeader">Institution</div>
                <input required className="cardInput" onChange={e => setInstitution(e.target.value)} value={institution} />
                <div className="cardHeader">Begin Date</div>
                <input required type="month" className="cardMonthInput" onChange={e => setBeginDate(e.target.value)} value={beginDate} />
                <div className="cardHeader">End Date</div>
                <input required type="month" className="cardMonthInput" onChange={e => setEndDate(e.target.value)} value={endDate} />
                <div className="cardHeader">Summary</div>
                <textarea className="cardInput" value={summary} onChange={e => setSummary(e.target.value)} />
            </form>
        )
    }

    if (props.noWorkExperience) {
        return (
            !editing ?
            <div className="errorCardContainer">
                No Work Experience Found!
                <span className="newBtn" onClick={handleEditClick}><i className="fas fa-pencil-alt"></i></span>
            </div>
            :
            <form className="cardContainer" autoComplete="off">
                <span className="cardBtns">
                    <button className="cancelBtn" onClick={handleEditClick}><i className="fas fa-ban"></i></button>
                    <button className="cardSubmit" type="submit" onClick={saveNewWorkExpInfo}><i className="fas fa-check"></i></button>
                </span>
                <br />
                <div className="cardHeader">Workplace</div>
                <input required className="cardInput" onChange={e => setWorkpalce(e.target.value)} value={workplace} />
                <div className="cardHeader">Title</div>
                <input required className="cardInput" onChange={e => setTitle(e.target.value)} value={title} />
                <div className="cardHeader">Begin Date</div>
                <input required type="month" className="cardMonthInput" onChange={e => setBeginDate(e.target.value)} value={beginDate} />
                <div className="cardHeader">End Date</div>
                <input required type="month" className="cardMonthInput" onChange={e => setEndDate(e.target.value)} value={endDate} />
                <div className="cardHeader">Summary</div>
                <textarea required className="cardInput" value={summary} onChange={e => setSummary(e.target.value)} />
            </form>
        )
    }

    if (props.noAddInfo) {
        return (
            !editing ?
            <div className="errorCardContainer">
                No Additional Information Found!
                <span className="newBtn" onClick={handleEditClick}><i className="fas fa-pencil-alt"></i></span>
            </div>
            :
            <form className="cardContainer" autoComplete="off">
                <span className="cardBtns">
                    <button className="cancelBtn" onClick={handleEditClick}><i className="fas fa-ban"></i></button>
                    <button className="cardSubmit" type="submit" onClick={saveNewAddInfo}><i className="fas fa-check"></i></button>
                </span>
                <br />
                <div className="cardHeader">Title</div>
                <input required className="cardInput" onChange={e => setTitle(e.target.value)} value={title} />
                <div className="cardHeader">Summary</div>
                <textarea required className="cardInput" value={summary} onChange={e => setSummary(e.target.value)} />
            </form>
        )
    }

    if (props.address) {
        if (!editing && (props.address1 === null || props.address1.length === 0)) { // no address listed
            return (
                <div className="errorCardContainer">
                    No Address Found!
                    <span className="newBtn" onClick={handleEditClick}><i className="fas fa-pencil-alt"></i></span>
                </div>
            )
        } else if (editing && props.address1 === null) { // expanded and editing with new data
            return (
                <form className="cardContainer" autoComplete="off">
                    <span className="cardBtns">
                        <button className="cancelBtn" onClick={handleEditClick}><i className="fas fa-ban"></i></button>
                        <button className="cardSubmit" type="submit" onClick={saveNewAddress}><i className="fas fa-check"></i></button>
                    </span>
                    <br />
                    <div className="cardHeader">Address 1</div>
                    <input required className="cardInput" onChange={e => setAddress1(e.target.value)} value={address1} />
                    <div className="cardHeader">Address 2</div>
                    <input className="cardInput" onChange={e => setAddress2(e.target.value)} value={address2} />
                    <div className="cardHeader">State</div>
                    <select required className="cardInput" onChange={e => setState(e.target.value)} value={state}>
                        <option disabled hidden value=''></option>
                        {props.states.map(renderState)}
                    </select>
                    <div className="cardHeader">City</div>
                    <select required className="cardInput" onChange={e => setCity(e.target.value)} value={city}>
                        <option disabled hidden value=''></option>
                        {cities && cities.map(renderCity)}
                    </select>
                    <div className="cardHeader">Postal</div>
                    <input required className="cardInput" onChange={e => setPostal(e.target.value)} value={postal} />
                </form>
            )
        } else if (!expandedView) { // compact view
            return (
                <div className="cardContainer">
                    {cities && getElementById(city, cities).name}, {props.states && getElementById(state, props.states).name}
                    <span className="editBtn" onClick={handleExpandClick}><i className="fas fa-chevron-down"></i></span>
                </div>
            )
        } else if (!editing) { // expanded and not editing
            return (
                <div className="cardContainer">
                    <span className="editBtn" onClick={handleEditClick}><i className="far fa-edit"></i></span>
                    {address1}<br />
                    {address2 && <span>{address2}<br /></span>}
                    {cities && getElementById(city, cities).name}, {props.states && getElementById(state, props.states).name} {postal}
                    <div className="unexpandBtn" onClick={handleExpandClick}><i className="fas fa-chevron-up"></i></div>
                </div>
            )
        } else if (editing) { // expanded and editing previous data
            return (
                <form className="cardContainer" autoComplete="off">
                    <span className="cardBtns">
                        <button className="cancelBtn" onClick={handleEditClick}><i className="fas fa-ban"></i></button>
                        <button className="cardSubmit" type="submit" onClick={saveEditedAddress}><i className="fas fa-check"></i></button>
                    </span>
                    <br />
                    <div className="cardHeader">Address 1</div>
                    <input required className="cardInput" onChange={e => setAddress1(e.target.value)} value={address1} />
                    <div className="cardHeader">Address 2</div>
                    <input className="cardInput" onChange={e => setAddress2(e.target.value)} value={address2} />
                    <div className="cardHeader">State</div>
                    <select required className="cardInput" onChange={e => setState(e.target.value)} value={state}>
                        <option disabled hidden value=''></option>
                        {props.states.map(renderState)}
                    </select>
                    <div className="cardHeader">City</div>
                    <select required className="cardInput" onChange={e => setCity(e.target.value)} value={city}>
                        <option disabled hidden value=''></option>
                        {cities && cities.map(renderCity)}
                    </select>
                    <div className="cardHeader">Postal</div>
                    <input required className="cardInput" onChange={e => setPostal(e.target.value)} value={postal} />
                </form>
            )
        }
    }

    return (<div />)
}

export default withAuth(Card)