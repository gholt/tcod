function processLine(e) {
    var line = e.target;
    switch (line.getAttribute("_type")) {
        case "reply":
        case "topic":
            var textnode = line.lastChild.firstChild;
            if (textnode.nodeValue.substr(1, 5) == "opic:" ||
                textnode.nodeValue.indexOf("has set topic:") >= 0) {
                thetopic = line.textContent;
                trim = thetopic.indexOf("opic:");
                if (trim > 0) {
                    thetopic = thetopic.substr(trim + 5);
                }
                thetopic = thetopic.replace(/</g, '&lt;');
                var div = document.getElementById("thetopic")
                if (div) {
                    div.innerHTML = thetopic;
                } else {
                    div = document.createElement("div");
                    div.setAttribute("id", "thetopic");
                    div.innerHTML = thetopic;
                    line.appendChild(div);
                }
            }
            break;
    }
}

document.addEventListener("DOMNodeInserted", processLine, true);
