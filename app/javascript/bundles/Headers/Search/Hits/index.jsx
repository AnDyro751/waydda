import React from 'react';
import {connectStateResults} from 'react-instantsearch-dom'
import {Hits} from 'react-instantsearch-dom'
import Hit from '../Hit'

export default connectStateResults(
    ({searchState, searchResults}) =>
        searchResults && searchResults.nbHits !== 0 ? (
            <Hits hitComponent={Hit}/>
        ) : (
            <div>
                No results found for <strong>{searchState.query}</strong>.
            </div>
        )
)
