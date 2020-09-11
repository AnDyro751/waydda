import Uppy from '@uppy/core'
import XHRUpload from '@uppy/xhr-upload';
import GetImageUrl from "../../../lib/getImageUrl";
import Choices from "choices.js";

import("choices.js/public/assets/styles/choices.min.css")
import('@uppy/core/dist/style.css')
import("@uppy/file-input/dist/style.css")
import('@uppy/status-bar/dist/style.css')

const StatusBar = require('@uppy/status-bar')
const es = import("@uppy/locales/lib/es_ES")


var select_element = document.querySelector(".js-multiple");
if (select_element) {
    const choices = new Choices(select_element, {
        placeholder: true,
        removeItemButton: true,
        noResultsText: "Sin resultados",
        loadingText: "Cargando...",
        noChoicesText: "No hay elementos disponibles",
        itemSelectText: "Click para seleccionar",
        placeholderValue: "Categorías",
        searchPlaceholderValue: "Categorías",
        classNames: {
            containerInner: 'px-3 py-3 rounded cursor-pointer mt-4 bg-main-gray',
            input: "main-input"
        }
    });
}


var element = document.querySelector(".UppyInput-Progress");
if (element) {
    var model = document.querySelector(`meta[name=content_model]`) ? document.querySelector("meta[name=content_model]").content : null
    var slug = document.querySelector(`meta[name=content_slug]`) ? document.querySelector("meta[name=content_slug]").content : null
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
        .use(XHRUpload, {endpoint: `/dashboard/upload/${model}/${slug}/photo`, limit: 1})
        .on('complete', (result) => {
            console.log('Upload result:', result)
            if (Array.isArray(result.successful)) {
                if (result.successful.length > 0) {
                    var current_result = result.successful[0];
                    if (current_result.response.status === 200) {
                        try {
                            document.querySelector(`#${model}_image`).src = GetImageUrl({
                                publicId: current_result.response.body.image_url,
                                height: 150,
                                width: 150
                            })
                            window.addFlashMessage("Se ha actualizado la imagen")
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
