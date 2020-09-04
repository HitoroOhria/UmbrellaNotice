// const SOCK_PATH = "tmp/sockets/next.sock";

// const { parse } = require("url");
// const fs = require("fs");
// const net = require("net");
// const next = require("next");

// const dev = process.env.NODE_ENV !== "production";
// const app = next({ dev });
// const handle = app.getRequestHandler();

// fs.unlinkSync(SOCK_PATH);

// app.prepare().then(() => {
//   const server = net.createServer((connection) => {
//     console.log("connected.");

//     connection.on("request", (req, res) => {
//       console.log("reqest.");
//       const parsedUrl = parse(req.url, true);

//       handle(req, res, parsedUrl);
//     });

//     connection.on("close", () => {
//       console.log("disconnected.");
//     });

//     connection.on("data", (data) => {
//       console.log("data.");
//       console.log(data.toString());
//     });

//     connection.on("error", (err) => {
//       console.log("error.");
//       console.error(err.message);
//     });

//     connection.end();
//   });

//   try {
//     fs.unlinkSync("/tmp/unix.sock");
//   } catch (error) {}

//   server.listen(SOCK_PATH);
//   fs.chmodSync(SOCK_PATH, "666");
// });
