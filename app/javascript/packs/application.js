// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";

Rails.start()
window.Rails = Rails;
require("turbolinks").start()
require("channels")
require('alpinejs')
import LazyLoad from "vanilla-lazyload";
import Toastify from 'toastify-js'
import "toastify-js/src/toastify.css";

import VanillaModal from 'vanilla-modal';

window.getScript = function (url) {
    var httpRequest = new XMLHttpRequest()
    httpRequest.onreadystatechange = function (data) {
        // code
    }
    httpRequest.open('GET', url)
    httpRequest.send()
};

document.addEventListener("turbolinks:load", function () {
    document.querySelector("body").classList.remove("overflow-hidden");

    window.vanillaModal = VanillaModal;
    var current_location = location.href;
    if (document.querySelector(".modal")) {
        window.current_modal = new window.vanillaModal({
            onBeforeClose: function () {
                console.log("befeore")
                history.replaceState({}, "", current_location);
            },
            onClose: () => {
                document.querySelector("#modal").innerHTML = "";
                document.querySelector("#modal-content").innerHTML = "";
            }
        });
    }
})

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
    let newRegion = arrayRegion.context.find((el) => el.id.includes("country"))
    if (newRegion) {
        if (newRegion.short_code) {
            return newRegion;
        } else {
            return null;
        }
    }
}

window.addFlashMessage = function (text, error = false) {
    document.querySelector("#notifications").innerHTML = `
                            <div class="z-20 bottom-0 mx-auto w-full mt-10">
                          <div id="flash-notice" class="transition w-full duration-300 truncate cursor-pointer px-4 py-4 text-white rounded ${error ? "bg-red-500" : "bg-indigo-600"}">
                            <p class="font-normal">${text}</p>
                          </div>
                        </div>
                            `
    window.deleteFlashs();
    window.scrollTo(0, 0);
}

window.getMapRecords = async function ({text, limit = 5}) {
    const URL = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(text)}.json?access_token=pk.eyJ1Ijoid2F5ZGRhIiwiYSI6ImNrZzYwZWJiYzB6bjMycW5udmd1NHNscDAifQ.wkmzM9Mh8XyPXZ8BgpyJXg&cachebuster=1596775236930&autocomplete=true&country=mx&limit=${limit}`;
    try {
        let response = await (
            await fetch(URL, {
                method: "GET"
            })
        ).json();
        return response.features;
    } catch (e) {
        return null;
    }
}
window.deleteFlashs = function deleteFlashNotice(custom_element = "#flash-notice", wrapper_element = "#notifications") {
    var class_element = document.querySelector(custom_element ? custom_element : "#flash-notice");
    if (class_element) {
        class_element.addEventListener("click", () => {
            var flashElement = document.querySelector(wrapper_element ? wrapper_element : "#notifications").innerHTML = ""
        }, false)
        setTimeout(() => {
            document.querySelector("#notifications").innerHTML = "";
        }, 10000)
    }
}


function getColor(color) {
    switch (color) {
        case "primary":
            return "#5f48f6"
            break;
        case "secondary":
            return "#2befb2";
            break;
        case "danger":
            return "#d43c27";
            break;
        default:
            return "#2befb2";
            break;
    }
}

window.addToastify = function addToastify(color = "primary", text = "") {

    var dismissableToast = window.Toastify({
        text: text,
        duration: 5000,
        close: true,
        gravity: "bottom", // `top` or `bottom`
        position: 'center', // `left`, `center` or `right`
        backgroundColor: getColor(color),
        stopOnFocus: true, // Prevents dismissing of toast on hover
        onClick: function () {
            if (dismissableToast) {
                dismissableToast.hideToast();
            }
        }, // Callback after click
        className: "w-full flex px-4 rounded font-medium text-sm py-3 border-2 border-black shadow-main"
    }).showToast();
}
Turbolinks.scroll = {};
let scrollPosition = null;

window.persistScroll = function (more = 0) {
    console.log("PERSISTIENDO A ", document.scrollingElement.scrollTop)
    Turbolinks.scroll['top'] = document.scrollingElement.scrollTop;
    document.addEventListener("turbolinks:before-render", () => {
        scrollPosition = window.scrollY;
    }, {once: true})
};

const turbolinksPersistScroll = () => {
    if (scrollPosition) {
        window.scrollTo(0, scrollPosition);
        scrollPosition = null;
    }
    const elements = document.querySelectorAll("[data-turbolinks-scroll]");
    elements.forEach(function (element) {
        element.addEventListener("click", () => {
            console.log("Click para", document.scrollingElement.scrollTop)
            Turbolinks.scroll['top'] = document.scrollingElement.scrollTop;
        });

        element.addEventListener("submit", () => {
            Turbolinks.scroll['top'] = document.scrollingElement.scrollTop;
        });

    });

    if (Turbolinks.scroll['top']) {
        console.log("Scroll to:", Turbolinks.scroll["top"]);
        document.scrollingElement.scrollTo(0, Turbolinks.scroll['top']);
    }

    Turbolinks.scroll = {};

}

document.addEventListener('turbolinks:render', turbolinksPersistScroll)
document.addEventListener("turbolinks:load", () => {
    console.log("LOAD")
    turbolinksPersistScroll();
    window.Toastify = Toastify;

    // function logElementEvent(eventName, element) {
    //     console.log(Date.now(), eventName, element.getAttribute("data-src"));
    // }
    //
    // var callback_enter = function (element) {
    //     logElementEvent("🔑 ENTERED", element);
    // };
    // var callback_exit = function (element) {
    //     logElementEvent("🚪 EXITED", element);
    // };
    // var callback_loading = function (element) {
    //     logElementEvent("⌚ LOADING", element);
    // };
    // var callback_loaded = function (element) {
    //     logElementEvent("👍 LOADED", element);
    // };
    // var callback_error = function (element) {
    //     logElementEvent("💀 ERROR", element);
    //     element.src =
    //         "https://via.placeholder.com/440x560/?text=Error+Placeholder";
    // };
    // var callback_finish = function () {
    //     logElementEvent("✔️ FINISHED", document.documentElement);
    // };
    // var callback_cancel = function (element) {
    //     logElementEvent("🔥 CANCEL", element);
    // };

    window.customLazyLoad = new LazyLoad({
        // Assign the callbacks defined above
        elements_selector: ".lazy",
        // callback_enter: callback_enter,
        // callback_exit: callback_exit,
        // callback_cancel: callback_cancel,
        // callback_loading: callback_loading,
        // callback_loaded: callback_loaded,
        // callback_error: callback_error,
        // callback_finish: callback_finish
    });

    try {
        const current_time_zone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        setCookie("timezone", current_time_zone);
    } catch (e) {

    }
    window.deleteFlashs()

})

const setCookie = (name, value) => {
    let expires = new Date();
    expires.setTime(expires.getTime() + (24 * 60 * 60 * 1000))
    document.cookie = name + "=" + value + ";expires=" + expires.toUTCString();
}