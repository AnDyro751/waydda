var ele = document.getElementById("scroll-container");
import VanillaModal from 'vanilla-modal';

window.vanillaModal = VanillaModal;
if (window.vanillaModal) {
    var current_location = location.href;
    window.current_modal = new window.vanillaModal({
        onBeforeClose: function () {
            console.log("BEOFRE");
            history.replaceState({}, "", current_location);
        },
        onClose: ()=>{
            document.querySelector("#modal").innerHTML = "";
            document.querySelector(".modal-content").innerHTML = "";
        }
    });
}
if (ele) {
    ele.style.cursor = 'grab';

    let pos = {top: 0, left: 0, x: 0, y: 0};

    const mouseDownHandler = function (e) {
        ele.style.cursor = 'grabbing';
        ele.style.userSelect = 'none';

        pos = {
            left: ele.scrollLeft,
            top: ele.scrollTop,
            // Get the current mouse position
            x: e.clientX,
            y: e.clientY,
        };

        document.addEventListener('mousemove', mouseMoveHandler);
        document.addEventListener('mouseup', mouseUpHandler);
    };

    const mouseMoveHandler = function (e) {
        // How far the mouse has been moved
        const dx = e.clientX - pos.x;
        const dy = e.clientY - pos.y;

        // Scroll the element
        ele.scrollTop = pos.top - dy;
        ele.scrollLeft = pos.left - dx;
    };

    const mouseUpHandler = function () {
        ele.style.cursor = 'grab';
        ele.style.removeProperty('user-select');

        document.removeEventListener('mousemove', mouseMoveHandler);
        document.removeEventListener('mouseup', mouseUpHandler);
    };
    ele.addEventListener('mousedown', mouseDownHandler);

    console.log("JOLA")
}
