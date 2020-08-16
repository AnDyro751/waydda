import React from 'react';
import SearchScreenContent from "./Content";

export default function SearchScreen({current_param}) {
    return (
        <div className="flex w-full">
            <SearchScreenContent current_param={current_param}/>
        </div>
    )
}
