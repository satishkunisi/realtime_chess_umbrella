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

const loadGame = (game) => {
  const channel = socket.channel(`game:${game.name}`, { username: game.username });
  channel.join();
  channel.on("drag_piece")
  return channel;
}

const joinGame = (loadedChannel, username, color) => {
  loadedChannel
    .push("join_game", { username: username, color: color })
    .on("ok", Game.setCurrent)
}

const dragPiece = (loadedChannel, color) => {
  loadedChannel
    .push("drag_piece", { color: color })
}

export { socket, createGame, loadGame, joinGame }
