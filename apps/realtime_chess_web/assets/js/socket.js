// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import { Socket } from "phoenix"
import * as Game from "./game";

const socket = (username) => { 
  const withUsername = new Socket("/socket", {params: {username: username}});
  withUsername.connect() 
  return withUsername;
}

const createGame = (username) => {
  const channel = socket(username).channel("game:lobby", { username })
  channel.on("go_to_game", payload => { 
    if (payload.username === username) {
      const game = Game.fromServer(username, payload);
      console.log(game);
    }
    // window.location = `/${game.name}`;    
  });

  channel.join();

  return channel;
}

const loadGame = (gameName, username) => {
  const channel = socket(username).channel(`game:${gameName}`, {body: { username: username }});
  channel.join();
  channel.on("receive_drag_piece", onReceiveDragPiece)
  return channel;
}

const joinGame = (loadedChannel, username, color) => {
  loadedChannel
    .push("join_game", { username: username, color: color })
    .on("ok", Game.setCurrent)
}

const onReceiveDragPiece = (body) => {
  // find piece by data-col, data-row
  // update piece style translate(x, y)

  const { elem, dx, dy } = body 
  document
    .querySelector(`[data-col="${elem['data-col']}"][data-row="${elem['data-row']}"]`)
    .setAttribute("style", `transform: translate(${dx}px, ${dy}px)`)
}

const sendDragPiece = (loadedChannel, attrs) => {
  loadedChannel
    .push("send_drag_piece", {body: attrs})
}

export { socket, createGame, loadGame, joinGame, sendDragPiece }
