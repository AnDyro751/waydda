// let allAddresses = [];
// async function fetchAddress(value) {
//     const URL = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(value)}.json?access_token=pk.pk.eyJ1Ijoid2F5ZGRhIiwiYSI6ImNrZzYwZWJiYzB6bjMycW5udmd1NHNscDAifQ.wkmzM9Mh8XyPXZ8BgpyJXg.JM5ZeqwEEm-Tonrk5wOOMw&cachebuster=1596775236930&autocomplete=true&country=mx&bbox=-102.36584333677,18.203715736351,-95.646605055518,20.200815919313&proximity=-99.630833,19.354167`;
//     try {
//         let response = await (await fetch(URL)).json();
//         if(response.features){
//             allAddresses = response.features;
//
//         }
//         console.log("ERROR", response)
//     } catch (e) {
//         console.log("ERROR", e)
//     }
// }
//
// let timer;
// export default function GetAddresses() {
//     var element = document.querySelector("#address_address")
//     if (element) {
//         element.addEventListener("input", (e) => {
//             console.log(e.target.value);
//             clearTimeout(timer);
//             if (e.target.value.length > 0) {
//                 timer = setTimeout(() => {
//                     fetchAddress(e.target.value);
//                 }, 1000)
//                 // Hacer la petición a mapbox
//             }
//         })
//     }
// }