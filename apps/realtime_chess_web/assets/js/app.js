// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import { createGame } from "./socket"

let username = null;
let channel = null;

const pieceDragListener = (event) => {
  event.dataTransfer.set('text/plain', 'This text may be dragged');  
} 

document.addEventListener("DOMContentLoaded", () => {
  const gameName = document.querySelector("[data-game-id]").dataset.gameId;

  const form = document.querySelector("#create-game-form");

  if (form) {
    form.querySelector('#create-game-form-submit').addEventListener("click", e => {
      e.preventDefault();
      username = form.querySelector('#username').value; 
      channel = createGame(username);
    })
  }

  const pieces = [...document.querySelectorAll('[data-piece]')]

  pieces.forEach(piece => {
    piece.addEventListener('ondragstart', pieceDragListener)
  })
})
