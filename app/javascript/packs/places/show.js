var ele = document.getElementById("scroll-container");
document.addEventListener("turbolinks:load", function () {
    var cartElement = document.querySelector("#get-my-cart");
    if (cartElement) {
        cartElement.addEventListener("ajax:beforeSend", function () {
            progressBar.setValue(0.2);
            progressBar.show();
        });
        cartElement.addEventListener("ajax:complete", function () {
            if (progressBar) {
                progressBar.setValue(1);
                progressBar.hide();
            }
        });
        var progressBar = new Turbolinks.ProgressBar()

    }
    var showModal = document.querySelector("meta[name=show-modal]");

    if (showModal) {
        if (showModal.content === "yes") {
            window.current_modal.open("#modal");
            var new_template = document.querySelector(".new-modal-content");
            var clone = document.importNode(new_template.content, true);
            document.querySelector(".modal-content").appendChild(clone);
            window.customLazyLoad.update();
            console.log(document.querySelectorAll(".button-select-modal").length, "LEN");

            document.querySelectorAll(".button-select-modal").forEach((el) => {
                console.log(el)
                el.addEventListener("click", () => {
                    document.querySelector(".divider-modal").classList.add("hidden");
                    document.querySelector("#button-pickup-modal").classList.add("hidden");
                    document.querySelector("#button-address-modal").classList.add("hidden");
                    if (el.id === "button-address-modal") {
                        document.querySelector("#delivery-form-modal").classList.remove("hidden");
                    }
                })

            });
        }
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

})
