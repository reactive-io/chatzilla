import "phoenix_html";

import React from "react";
import ReactDom from "react-dom";

import Chat from "./app/chat";

ReactDom.render(<Chat topic="rooms:lobby" />, document.getElementById("react-app"));
