import React from "react"
import PropTypes from "prop-types"

export default function DashboardPlacePresentation({image}) {
    return (
        <>
            Image: {image}
        </>
    )
}
DashboardPlacePresentation.propTypes = {
    image: PropTypes.string
};
