document.addEventListener("turbolinks:load", () => {
    const element = document.querySelector("#cart_item_quantity")
    console.log(element)
    if (element) {
        element.addEventListener("change", (e) => {
            console.log(e.target.value)
        })
    }
})

