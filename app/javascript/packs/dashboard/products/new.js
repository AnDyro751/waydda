import Uppy from '@uppy/core'
import XHRUpload from '@uppy/xhr-upload';
import GetImageUrl from "../../../lib/getImageUrl";

import("choices.js/public/assets/styles/choices.min.css")
import('@uppy/core/dist/style.css')
import("@uppy/file-input/dist/style.css")
import('@uppy/status-bar/dist/style.css')

const StatusBar = require('@uppy/status-bar');
const es = import("@uppy/locales/lib/es_ES");


var element = document.querySelector(".UppyInput-Progress");
if (element) {
    var model = document.querySelector(`meta[name=content_model]`) ? document.querySelector("meta[name=content_model]").content : null
    var slug = document.querySelector(`meta[name=content_slug]`) ? document.querySelector("meta[name=content_slug]").content : null
    var attribute = document.querySelector("meta[name=content_attribute]") ? document.querySelector("meta[name=content_attribute]").content : "photo"
    const uppyOne = new Uppy({
        debug: true, autoProceed: true,
        restrictions: {
            maxNumberOfFiles: 1,
            allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.png'],
        },
        locale: es,
    });
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
        .use(XHRUpload, {endpoint: `/dashboard/upload/${model}/${slug}/${attribute}`, limit: 1})
        .on('complete', (result) => {
            console.log('Upload result:', result);
            if (Array.isArray(result.successful)) {
                if (result.successful.length > 0) {
                    var current_result = result.successful[0];
                    if (current_result.response.status === 200) {
                        try {
                            document.querySelector(`#${model}_image`).src = GetImageUrl({
                                publicId: current_result.response.body.image_url,
                                height: 250,
                                width: 250,
                                fit: "contain"
                            });

                            window.addFlashMessage("Se ha actualizado la imagen")
                            uppyOne.reset()
                        } catch (e) {
                            console.log("HOLA", e)
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
                    data: file,
                    id: "new_photo"
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
