// ==UserScript==
// @name        Helpers for http://localhost:8642/
// @namespace   Violentmonkey Scripts
// @match       http://localhost:8642/*
// @grant       none
// @version     1.0
// @author      letientai299
// ==/UserScript==

//------------------------------------------------------------------------------
// This script add mermaidJS support for local website served using markserv
// (https://github.com/markserv/markserv)
//------------------------------------------------------------------------------

function loadMermaid() {
  [...document.querySelectorAll("pre > code.language-mermaid")].forEach((e) => {
    const pre = e.parentNode;
    const code = e.textContent;
    console.log(code);
    pre.textContent = `${code}`;
    pre.style.width = "100%";
    pre.classList.add("mermaid");
  });

  const script = document.createElement("script");
  script.type = "module";
  script.innerText = `
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
let config = { startOnLoad: true, flowchart: { useMaxWidth: true, htmlLabels: true } };
mermaid.initialize(config);
`;
  document.head.appendChild(script);
}

loadMermaid();

// Add extra margin at the bottom the page to read the bottom text easier,
// similar to how vim's zz handle the last line, or "Show virtual space at the
// bottom of the file" in Jetrains IDE.
// https://www.jetbrains.com/help/idea/settings-editor-general.html
document.body.style.marginBottom = "50svh";
