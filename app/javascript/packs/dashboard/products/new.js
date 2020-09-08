import Uppy from '@uppy/core'
import XHRUpload from '@uppy/xhr-upload';
import GetImageUrl from "../../../lib/getImageUrl";

// const FileInput = require('@uppy/file-input')
const StatusBar = require('@uppy/status-bar')

// import Dashboard from '@uppy/dashboard'

const es = import("@uppy/locales/lib/es_ES")
import('@uppy/core/dist/style.css')
import("@uppy/file-input/dist/style.css")
import('@uppy/status-bar/dist/style.css')

var element = document.querySelector(".UppyInput-Progress");
if (element) {
    var slug = document.querySelector("meta[name=product_slug]") ? document.querySelector("meta[name=product_slug]").content : null
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
        .use(XHRUpload, {endpoint: `/dashboard/upload/product/${slug}/photo`, limit: 1})
        .on('complete', (result) => {
            console.log('Upload result:', result)
            if (Array.isArray(result.successful)) {
                if (result.successful.length > 0) {
                    var current_result = result.successful[0];
                    if (current_result.response.status === 200) {
                        try {
                            document.querySelector("#product_image").src = GetImageUrl({
                                publicId: current_result.response.body.image_url,
                                height: 150,
                                width: 150
                            })
                            window.addFlashMessage("La foto del producto se a actualizado")
                        } catch (e) {
                            window.addFlashMessage("Ha ocurrido un error al actualizar la imagen", true)
                        }

                    }
                }
            }
        });

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

}
