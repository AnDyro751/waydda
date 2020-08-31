// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("channels")
require('alpinejs')
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import '../../assets/stylesheets/application.scss'

// import Uppy from '@uppy/core'
// import Dashboard from '@uppy/dashboard'

// const ImageEditor = require('@uppy/image-editor')
// const XHRUpload = require('@uppy/xhr-upload')
// const es = require("@uppy/locales/lib/es_ES")
// require('@uppy/core/dist/style.css')
// require('@uppy/dashboard/dist/style.css')

// document.addEventListener("turbolinks:load", () => {
//     const el = document.querySelector("#select-files")
//     if (el) {
//         const model = el["dataset"].model
//         const slug = el["dataset"].slug
//         const attribute = el["dataset"].attribute
//         Uppy({
//             allowMultipleUploads: false,
//             restrictions: {
//                 maxFileSize: 10 * 1024 * 1024,
//                 maxNumberOfFiles: 1,
//                 minNumberOfFiles: 0,
//                 allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.png'],
//             },
//         })
//             .use(Dashboard, {
//                 trigger: '#select-files',
//                 showProgressDetails: true,
//                 browserBackButtonClose: true,
//                 closeAfterFinish: true,
//                 locale: es,
//                 note: "Imágenes solamente hasta 10 MB"
//             })
//             .use(XHRUpload, {endpoint: `/dashboard/upload/${model}/${slug}/${attribute}`, limit: 1})
//             .on('complete', (result) => {
//                 console.log('Upload result:', result)
//             })
//     }
// })// Support component names relative to this directory:
// var componentRequireContext = require.context("components", true);
// var ReactRailsUJS = require("react_ujs");
// ReactRailsUJS.useContext(componentRequireContext);

window.findRegion = function (arrayRegion) {
    let newRegion = arrayRegion.context.find((el) => el.id.includes("region"))
    let newPlace = arrayRegion.context.find((el) => el.id.includes("place"))
    if (newRegion) {
        if (newRegion.short_code) {
            return newRegion;
        } else {
            return null;
        }
    } else {
        if (newPlace) {
            if (newPlace.short_code) {
                return newPlace
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
}

window.addFlashMessage = function (text, error = false) {
    document.querySelector("#notifications").innerHTML = `
                            <div class="z-20 bottom-0 mx-auto w-9/12 mt-10">
                          <div id="flash-notice" class="transition w-full duration-300 truncate cursor-pointer px-4 py-4 text-white rounded ${error ? "bg-red-500" : "bg-indigo-600"}">
                            <p class="font-normal">${text}</p>
                          </div>
                        </div>
                            `
    window.deleteFlashs();
    window.scrollTo(0, 0);
}

window.deleteFlashs = function deleteFlashNotice() {
    var class_element = document.querySelector("#flash-notice");
    console.log(class_element)
    if (class_element) {
        class_element.addEventListener("click", () => {
            var flashElement = document.querySelector("#notifications").innerHTML = ""
        }, false)
    }
}

document.addEventListener("turbolinks:load", () => {

    window.deleteFlashs()
    try {
        const current_time_zone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        setCookie("timezone", current_time_zone);
    } catch (e) {

    }
})

const setCookie = (name, value) => {
    let expires = new Date();
    expires.setTime(expires.getTime() + (24 * 60 * 60 * 1000))
    document.cookie = name + "=" + value + ";expires=" + expires.toUTCString();
}