import React, {useState, useEffect} from 'react';
import {FaSearch} from 'react-icons/fa'
// import {SearchBox, InstantSearch, Hits} from 'react-instantsearch-dom';
// import algoliasearch from 'algoliasearch'
//
// const searchClient = algoliasearch(
//     'QS0YKUA3HP',
//     'e32570050b0f2d30e7ad56cd5dd00e17'
// );
export default function Search({current_param}) {
    const [searchState, setSearchState] = useState(current_param || "");

    const handleSubmit = (e) => {
        e.preventDefault();
        Turbolinks.visit(`/search?query=${searchState}`)
    }

    return (
        <form
            onSubmit={handleSubmit}
            className="w-full relative">
            <div className="absolute top-0 flex justify-center items-center left-0 bottom-0 h-full ml-4">
                <FaSearch className={"inline"}/>
            </div>
            <input type="search"
                   value={searchState}
                   onChange={(e) => {
                       setSearchState(e.target.value)
                   }}
                   autoFocus={current_param ? true : false}
                   style={{
                       backgroundColor: "#F6F6F6"
                   }}
                   className="py-3 pl-12 pr-5 border-b border-gray-400 focus:outline-none w-full"
                   placeholder={"Busca en tu ciudad"}
            />
        </form>
    )
}
