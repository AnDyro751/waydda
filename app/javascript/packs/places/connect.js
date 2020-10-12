import getDefaultHeaders from "../../lib/getDefaultHeaders";

var connectElement = document.querySelectorAll(".get-to-my-dashboard");
if (connectElement.length > 0) {
    console.log("SI HAY");
    connectElement.forEach((el) => {
        el.addEventListener("click", async () => {
            console.log("CLICK");
            try {
                el.innerHTML = "Cargando...";
                el.disabled = true;
                var response = await (
                    (await fetch("/dashboard/settings/payments/connect/link", {
                        method: "POST",
                        headers: getDefaultHeaders()
                    })).json()
                );
                if (response.errors) {
                    el.disabled = false;
                    window.addFlashMessage(response.errors, true);
                    el.innerHTML = "Intentar de nuevo";
                } else {
                    window.location = response.link;
                }
                console.log(response)
            } catch (e) {
                el.disabled = false;
                window.addFlashMessage("Ha ocurrido un error", true);
                el.innerHTML = "Intentar de nuevo";
            }
        })
    })

}
