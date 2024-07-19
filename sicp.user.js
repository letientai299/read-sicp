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
  enableCopyContent(a.parentNode.parentNode.parentNode, a.id);
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

function enableCopyContent(elem, id) {
  focusable(elem);
  handleIfMatch(elem, ["click", "keydown"], isExpected, () => {
    remember(id);
    navigator.clipboard.writeText(elem.innerText);
  });
  highlight(elem);
}

function enableCopyLink(elem, id) {
  focusable(elem);
  highlight(elem);
  const loc = document.location;
  const url = `${loc.protocol}//${loc.host}${loc.pathname}#${id}`;

  handleIfMatch(elem, ["click", "keydown"], isExpected, () => {
    remember(id);
    navigator.clipboard.writeText(url);
  });
}
function highlight(elem) {
  handleIfMatch(
    elem,
    ["keypress", "keyup", "mouseup", "mousedown"],
    isExpected,
    (event) => {
      elem.style.opacity = ["keypress", "mousedown"].includes(event.type)
        ? 0.5
        : 1;
    }
  );
}

function focusable(elem) {
  elem.tabIndex = 0;
  handleIfMatch(elem, ["mouseover", "focus"], true, () => {
    elem.style.outline = `5px auto red`;
  });

  handleIfMatch(elem, ["mouseout", "blur"], true, () => {
    elem.style.outline = ``;
  });
}

function handleIfMatch(elem, types, match, handle) {
  types.forEach((type) =>
    elem.addEventListener(type, (event) => {
      const ok = (typeof match === "boolean" && match === true) || match(event);
      if (ok) {
        swallow(event);
        handle(event);
      }
    })
  );
}

function isExpected(event) {
  return event.type === "click" || event.code === "Enter";
}

function swallow(event) {
  event.stopPropagation();
}

document.addEventListener("keypress", (event) => {
  if (event.code !== "KeyP" || !event.ctrlKey) {
    return;
  }
  gotoPinned();
});

function gotoPinned() {
  const id = localStorage.getItem("pin");
  if (!id) {
    return;
  }

  const elem = document.getElementById(id);
  if (!elem) {
    return;
  }

  elem.scrollIntoView({
    behavior: "smooth",
    block: "center",
    inline: "center",
  });
}

function remember(id) {
  if (id) {
    localStorage.setItem("pin", id);
  }
}
