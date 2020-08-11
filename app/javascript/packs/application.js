// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("channels")

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
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
