import React, {useEffect} from 'react';
import algoliasearch from 'algoliasearch/lite';

var client = algoliasearch("QS0YKUA3HP", "e32570050b0f2d30e7ad56cd5dd00e17");
var index = client.initIndex('Place');

export default function SearchScreenContent({current_param}) {
    useEffect(() => {
        console.log("HOLA")

        index.search(current_param, {
            hitsPerPage: 10,
            page: 0,
            attributesToRetrieve: ['name', 'street', 'slug'],
            aroundLatLng: '16.660130, -96.728782',
            aroundRadius: 15000, // RADIO DE 15km,
            facets: [
                'attribute',
            ],
            tagFilters: [
                "mx"
            ]
        })
            .then(function searchDone(content) {
                console.log(content)
            })
            .catch(function searchFailure(err) {
                console.error(err);
            });
    }, [])
    return (
        <div>
            <h1>Hola</h1>
        </div>
    )
}