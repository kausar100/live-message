// importing modules
require('dotenv').config();
const express = require("express");
const http = require("http");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);

const User = require('./models/person');
const Room = require('./models/channel');

var io = require("socket.io")(server);

// middle ware
app.use(express.json());
require('./config/db');


app.get('/', (req, res) => {
  res.send("Node server is running.");
});


io.on('connection', (socket) => {
  console.log("connected!");

  socket.on("onLoginUser", async ({ email, password }) => {
    try {
      const user = await User.findOne({ email: email }).select({__v:0});
      console.log(user);
      if (user!=null) {
        //match password
        const match = password == user.password
        if (!match) {
          socket.emit("errorOccurred", "Password don't match!.");
        } else {
          //login success
          socket.emit("onLoginSuccess", { user });
        }
       
      } else {
        socket.emit("errorOccurred", "User not registered.");
      }

    } catch (e) {
      console.log(e);
    }
  });

  socket.on("onRegisterUser", async ({ name, email, password }) => {
    try {
      //check already exist or not
      const found = await User.findOne({ email: email });
      if (found) {
        socket.emit("errorOccurred", "User already exist.");
      } else {
        //new user
        const newUser = User({
          name,
          email,
          password,
          socketID: socket.id,
        });

        const result = await newUser.save();

        if (result != null) {
          const data = await User.findById(result._id).select({ password: 0, __v: 0 });
          socket.emit("onRegistrationSuccess", { data });
        } else {
          socket.emit("errorOccurred", "Registration failed");
        }

      }
    } catch (e) {
      console.log(e);
    }
  });


  // //Get the chatID of the user and join in a room of the same chatID
  // chatID = socket.handshake.query.chatID
  // socket.join(chatID)

  // //Leave the room if the user closes the socket
  // socket.on('disconnect', () => {
  //     socket.leave(chatID)
  // })

  // //Send message to only a particular user
  // socket.on('send_message', message => {
  //     receiverChatID = message.receiverChatID
  //     senderChatID = message.senderChatID
  //     content = message.content

  //     //Send message to only that particular room
  //     socket.in(receiverChatID).emit('receive_message', {
  //         'content': content,
  //         'senderChatID': senderChatID,
  //         'receiverChatID':receiverChatID,
  //     })
  // })
});


server.listen(port, () => {
  console.log(`server is running at http://127.0.0.1:${port}`)
})