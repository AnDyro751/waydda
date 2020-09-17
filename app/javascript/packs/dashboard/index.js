import VanillaModal from 'vanilla-modal';

window.vanillaModal = VanillaModal;

document.addEventListener("turbolinks:load", () => {
    var element = document.querySelector("#modal");
    if (element) {
        if (window.vanillaModal) {
            var current_location = location.href;
            window.current_modal = new window.vanillaModal({
                onBeforeClose: function () {
                    history.replaceState({}, "", current_location);
                },
                onClose: () => {
                    document.querySelector("#modal").innerHTML = "";
                    document.querySelector("#modal-content").innerHTML = "";
                }
            });
        }
    }
})