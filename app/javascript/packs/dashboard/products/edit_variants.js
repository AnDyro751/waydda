if (document.querySelector("#list_variants")) {
    var elements = document.querySelectorAll(".remove-child");
    elements.forEach((el) => {
        console.log(el)

        el.addEventListener("click", () => {
            console.log("CLICK")
            document.querySelector("#all-variants").removeChild(el.parentNode.parentNode);
        })
    });
}
