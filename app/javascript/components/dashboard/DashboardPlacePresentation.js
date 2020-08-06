import React from "react"
import PropTypes from "prop-types"

export default function DashboardPlacePresentation({image}) {
    return (
        <>
            <img src={image} alt="Profile picture"/>
        </>
    )
}
DashboardPlacePresentation.propTypes = {
    image: PropTypes.string
};
