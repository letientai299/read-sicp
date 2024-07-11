// ==UserScript==
// @name        Helpers for https://sarabander.github.io/sicp
// @namespace   Violentmonkey Scripts
// @match       https://sarabander.github.io/sicp/*
// @grant       none
// @version     1.0
// @author      letientai299
// ==/UserScript==

//------------------------------------------------------------------------------
// This script add some userful interactions with the book website.
//
// - Add tabIndex on these elements: headers, code block, figure, exercise. So,
// we can use tab to jumps between sections quicker.
//
// - Handle mouse clicks and Enter on those elements, which will:
//   - Trigger copy link with anchor ID for headers and figure, to paste into
//   the note as referrence links.
//   - Trigger copy inner text content for code block and exercise, to prepare
//   our notes.
//------------------------------------------------------------------------------

const headerTags = ["h1", "h2", "h3", "h4", "h5", "h6"];
const linkHandlers = [
  { pattern: /^Figure\-.*$/, fn: configFigure },
  { pattern: /^Exercise\-.*$/, fn: configExercise },
  { pattern: /^[A-Z]\w+\b(-\w+)*$/, fn: configHeader },
];

[...document.getElementsByTagName("a")].forEach((a) => {
  // any clickable link (that has non empty inner text) should be tab-able.
  if (a.innerText !== "") {
    a.tabIndex = 0;
    return;
  }

  for (const cfg of linkHandlers) {
    if (cfg.pattern.test(a.id)) {
      cfg.fn(a);
    }
  }
});

[...document.getElementsByTagName("pre")].forEach(enableCopyContent);

function configExercise(a) {
  enableCopyContent(a.parentNode.parentNode.parentNode);
}

function configFigure(a) {
  enableCopyLink(a.parentNode, a.id);
}

function configHeader(a) {
  const h = findHeader(a);
  if (h) {
    enableCopyLink(h, a.id);
  }
}

function findHeader(from) {
  let h = from.nextElementSibling;
  while (h && !headerTags.includes(h.tagName)) {
    h = h.nextElementSibling;
  }
  return h;
}

function enableCopyContent(elem) {
  focusable(elem);
  highlightOnKeyPress(elem);
  const content = elem.innerText;
  elem.addEventListener("click", () => navigator.clipboard.writeText(content));
  elem.addEventListener("keydown", (event) => {
    if (isExpectedKeyCode(event)) {
      navigator.clipboard.writeText(content);
    }
  });
}

function enableCopyLink(elem, id) {
  focusable(elem);
  highlightOnKeyPress(elem);

  const loc = document.location;
  const url = `${loc.protocol}//${loc.host}${loc.pathname}#${id}`;
  elem.addEventListener("click", () => navigator.clipboard.writeText(url));
  elem.addEventListener("keydown", (event) => {
    if (isExpectedKeyCode(event)) {
      navigator.clipboard.writeText(url);
    }
  });
}

function highlightOnKeyPress(elem) {
  elem.addEventListener("keypress", (event) => {
    if (isExpectedKeyCode(event)) {
      elem.style.opacity = 0.5;
      event.preventDefault();
    }
  });

  elem.addEventListener("keyup", (event) => {
    if (isExpectedKeyCode(event)) {
      elem.style.opacity = 1;
      event.preventDefault();
    }
  });
}

function isExpectedKeyCode(event) {
  return event.code === "Enter";
}

function focusable(elem) {
  elem.tabIndex = 0;
  ["mouseover", "focus"].forEach((event) => {
    elem.addEventListener(event, () => setOutline(elem));
  });

  ["mouseout", "blur"].forEach((event) => {
    elem.addEventListener(event, () => clearOutline(elem));
  });
}

function setOutline(elem) {
  elem.style.outline = `5px auto red`;
}

function clearOutline(elem) {
  elem.style.outline = ``;
}
