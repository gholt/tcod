function processLine(e) {
    var line = e.target;
    switch (line.getAttribute("_type")) {
        case "reply":
        case "topic":
            var textnode = line.lastChild.firstChild;
            if (textnode.nodeValue.substr(1, 5) == "opic:" ||
                textnode.nodeValue.indexOf("has set topic:") >= 0) {
                var newdiv = document.createElement("div");
                newdiv.setAttribute("id", "thetopic");
                thetopic = line.textContent;
                trim = thetopic.indexOf("opic:");
                if (trim > 0) {
                    thetopic = thetopic.substr(trim + 5);
                }
                newdiv.innerHTML = thetopic.replace(/</g, '&lt;');
                line.appendChild(newdiv);
            }
            break;
    }
}

document.addEventListener("DOMNodeInserted", processLine, true);
