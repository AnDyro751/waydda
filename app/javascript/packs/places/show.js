var ele = document.getElementById("scroll-container");
document.addEventListener("turbolinks:load", function () {
    console.log("window", window.current_modal)
    window.current_modal.open("#modal");
    var new_template = document.querySelector(".new-modal-content");
    var clone = document.importNode(new_template.content, true);
    document.querySelector(".modal-content").appendChild(clone);
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

})
