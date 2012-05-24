function processLine(e) {
    var line = e.target;
    switch (line.getAttribute("type")) {
        case "reply":
            var textnode = line.lastChild.firstChild;
            if (textnode.nodeValue.substr(0, 6) == "Topic:") {
                var newdiv = document.createElement("div");
                newdiv.setAttribute("id", "thetopic");
                thetopic = line.textContent;
                trim = thetopic.indexOf("Topic:");
                if (trim > 0) {
                    thetopic = thetopic.substr(trim + 6);
                }
                newdiv.innerHTML = thetopic;
                line.appendChild(newdiv);
            }
            break;
    }
}

document.addEventListener("DOMNodeInserted", processLine, true);
