import React from 'react';
import GetImageUrl from "../../lib/getImageUrl";
import {LazyLoadImage} from "react-lazy-load-image-component";

export default function ResponsiveImage({scrollPosition, srcsetSizes, byDefault = false, className = "", alt, publicId = "", width = 2000, height = 100, fit = "outside", bgColor = null, wrapperClass = ""}) {

    return (
        <LazyLoadImage
            scrollPosition={scrollPosition}
            alt={alt}
            className={`${className}`}
            wrapperClassName={wrapperClass}
            effect="blur"
            visibleByDefault={byDefault}
            draggable={false}
            placeholderSrc={GetImageUrl({publicId, width: 50, height: 50, fit, bgColor})}
            src={GetImageUrl({publicId, height, width, fit, bgColor})}
            sources='(min-width:1920px) 1920w, 100vw'
            srcSet={`
			${GetImageUrl({
                publicId,
                width: srcsetSizes ? srcsetSizes.w_480.width : 480,
                height: srcsetSizes ? srcsetSizes.w_480.height : 480,
                fit,
                bgColor
            })} 480w,
			${GetImageUrl({
                publicId,
                width: srcsetSizes ? srcsetSizes.w_1082.width : 800,
                height: srcsetSizes ? srcsetSizes.w_1082.height : 800,
                fit,
                bgColor
            })} 1082w,
			${GetImageUrl({
                publicId,
                width: srcsetSizes ? srcsetSizes.w_1523.width : 1000,
                height: srcsetSizes ? srcsetSizes.w_1523.height : 1000,
                fit,
                bgColor
            })} 1523w,
			${GetImageUrl({
                publicId,
                width: srcsetSizes ? srcsetSizes.w_1920.width : 1200,
                height: srcsetSizes ? srcsetSizes.w_1920.height : 1200,
                fit,
                bgColor
            })} 1920w,
			`}
        />
    )
}