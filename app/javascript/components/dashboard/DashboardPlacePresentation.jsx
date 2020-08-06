import React from "react"
import PropTypes from "prop-types"
import GetImageUrl from "../../lib/getImageUrl";
export default function DashboardPlacePresentation({place, id}) {
    return (
        <>
            <img className="h-10 w-10" src={GetImageUrl({publicId: place.photo, height: 50, width: 50})}
                 alt="Profile picture"/>
            {place.status !== "pending" &&
            <button id="select-files" data-model="place" data-slug={id} data-attribute="photo">Seleccionar
                archivos</button>
            }
        </>
    )
}
DashboardPlacePresentation.propTypes = {
    place: PropTypes.object.isRequired,
    id: PropTypes.string.isRequired,
};
