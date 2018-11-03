let t = {
  username: "username",
  name: "somename",
  userColor: "white",
  board: {"0": {"0": null}},
  gameState: "started"
};

const fromServer = (username, payload) => (
  {
    username: username,
    name: payload.name,
    userColor: (username === payload.player_white) ? "white" : "black",
    board: payload.board,
    status: payload.status
  }
)

let currentGame = null;

const setCurrent = (game) => {
  currentGame = game;
}

export { fromServer, setCurrent, currentGame }
