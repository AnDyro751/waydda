import Uppy from '@uppy/core'
import XHRUpload from '@uppy/xhr-upload';

const FileInput = require('@uppy/file-input')
const StatusBar = require('@uppy/status-bar')

// import Dashboard from '@uppy/dashboard'

const es = import("@uppy/locales/lib/es_ES")
import('@uppy/core/dist/style.css')
import("@uppy/file-input/dist/style.css")
import('@uppy/status-bar/dist/style.css')

var element = document.querySelector(".UppyInput-Progress");
if (element) {
    const uppyOne = new Uppy({
        debug: true, autoProceed: true,
        restrictions: {
            maxNumberOfFiles: 1,
            allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.png'],
        },
        locale: es,
    })
    uppyOne
        // .use(FileInput, {
        //     target: '.UppyInput',
        //     pretty: false,
        //     locale: es
        // })
        .use(StatusBar, {
            target: '.UppyInput-Progress',
            hideUploadButton: true,
            hideAfterFinish: true
        })
        .use(XHRUpload, {endpoint: `/dashboard/upload/product/demo/image`, limit: 1});

    const fileInput = document.querySelector('#my-file-input')

    fileInput.addEventListener('change', (event) => {
        console.log("HOLA")
        const files = Array.from(event.target.files)

        files.forEach((file) => {
            try {
                uppyOne.addFile({
                    source: 'file input',
                    name: file.name,
                    type: file.type,
                    data: file
                })
            } catch (err) {
                if (err.isRestriction) {
                    // handle restrictions
                    console.log('Restriction error:', err)
                } else {
                    // handle other errors
                    console.error(err)
                }
            }
        })
    })
    console.log("HOLA");
    // Uppy({
    //     debug: true,
    //     allowMultipleUploads: false,
    //     restrictions: {
    //         maxFileSize: 10 * 1024 * 1024,
    //         maxNumberOfFiles: 1,
    //         minNumberOfFiles: 0,
    //         allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.png'],
    //     },
    // })
    //     .use(Dashboard, {
    //         trigger: '#select-files',
    //         showProgressDetails: true,
    //         browserBackButtonClose: true,
    //         closeAfterFinish: true,
    //         locale: es,
    //         note: "Hasta 10 MB por imagen"
    //     })
    //     .use(XHRUpload, {endpoint: `/dashboard/upload/product/demo/image`, limit: 1})
    //     .on('complete', (result) => {
    //         console.log('Upload result:', result)
    //     })
}
