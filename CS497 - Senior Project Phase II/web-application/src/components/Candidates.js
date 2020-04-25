import React, { useState } from 'react'
import CandidateSearch from './CandidateSearch'
import CandidateTable from './CandidateTable'
import ExcelExport from './ExcelExport'

function Candidates(props) {
    const [candidates, setCandidates] = useState(props.candidates)
    const [searchText, setSearchText] = useState('')

    return (
        <div className="pagewrapper">
            <h1 className="pageHeaderTitle">Candidates</h1>
            <ExcelExport searchText={searchText} />
            <CandidateSearch searchTextChange={setSearchText} searchText={searchText} setCandidates={setCandidates} />
            <CandidateTable 
                candidates={candidates}
                convertDate={props.convertDate}
            />
        </div>
    )
}

export default Candidates