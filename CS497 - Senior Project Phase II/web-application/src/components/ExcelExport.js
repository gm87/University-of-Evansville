import React from 'react'
import { withAuth } from '@okta/okta-react'

const ExcelExport = props => {

    const getExport = async () => {
        const { searchText } = props
        fetch(`${process.env.REACT_APP_FETCH_SERVER_URL}/candidates/excel?text=${searchText}`, {
            method: 'GET',
            headers: {
                'content-type': 'application/json',
                accept: 'application/json',
                authorization: `Bearer ${await props.auth.getAccessToken()}`
            }
        })
        .then(response => response.blob())
        .then(blob => {
            var url = window.URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = "Report.xlsx";
            document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
            a.click();    
            a.remove();  //afterwards we remove the element again         
        })
        .catch(err => console.log(err))
    }

    return(
        <span className="excelBtn" onClick={getExport}><i className="fas fa-file-excel" /></span>
    )
}

export default withAuth(ExcelExport)