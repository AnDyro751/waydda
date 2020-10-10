import {Base64} from 'js-base64';
import hexRgb from 'hex-rgb'

const GetImageUrl = ({publicId = "", width = 500, height = 500, fit = "outside", bgColor = null}) => {
    let options = JSON.stringify({
        "bucket": "waydda-qr",
        "key": publicId,
        "edits": {
            "resize": {
                "width": width || height,
                "height": height || width,
                "fit": fit,
                background: {
                    "r": 255,
                    "g": 255,
                    "b": 255,
                    "alpha": 1
                }
            }
        }
    })
    return `https://d1nrrr6y3ujrjz.cloudfront.net/${Base64.encode(options)}`
}

export default GetImageUrl