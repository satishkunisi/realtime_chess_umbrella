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

import * as Socket from "./socket"

let username = null;
let channel = null;

const getPieceAttributes = (event) => {
  return { 
    dx: event.offsetX,
    dy: event.offsetY,
    elem: { 
      "data-col": event.target.dataset.col,
      "data-row": event.target.dataset.row 
    }
  }
}

const pieceDragListener = (event) => {
  const attrs = getPieceAttributes(event)
  Socket.sendDragPiece(channel, attrs);
} 

document.addEventListener("DOMContentLoaded", () => {
  const meta = document.querySelector("[data-game-id]")
  const gameName = meta && meta.dataset.gameId;

  const form = document.querySelector("#create-game-form");

  if (gameName) {
    channel = Socket.loadGame(gameName, "username1")
  }

  if (form) {
    form.querySelector('#create-game-form-submit').addEventListener("click", e => {
      e.preventDefault();
      username = form.querySelector('#username').value; 
      channel = Socket.createGame(username);
    })
  }

  const pieces = [...document.querySelectorAll('[data-piece]')]

  pieces.forEach(piece => {
    piece.addEventListener('drag', pieceDragListener)
  })
})
