import getDefaultHeaders from "../../lib/getDefaultHeaders";

var connectElement = document.querySelector(".get-to-my-dashboard");
if (connectElement) {
    connectElement.addEventListener("click", async () => {
        try {
            connectElement.innerHTML = "Cargando...";
            connectElement.disabled = true;
            var response = await (
                (await fetch("/dashboard/settings/payments/connect/link", {
                    method: "POST",
                    headers: getDefaultHeaders()
                })).json()
            )
            if (response.errors) {
                connectElement.disabled = false;
                window.addFlashMessage(response.errors, true);
                connectElement.innerHTML = "Intentar de nuevo";
            } else {
                window.location = response.link;
            }
            console.log(response)
        } catch (e) {
            connectElement.disabled = false;
            window.addFlashMessage("Ha ocurrido un error", true);
            connectElement.innerHTML = "Intentar de nuevo";
        }
    })
}
