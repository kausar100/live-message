// importing modules
require('dotenv').config();
const express = require("express");
const http = require("http");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);

const User = require('./models/person');
const Message = require("./models/message");

var io = require("socket.io")(server);

// middle ware
app.use(express.json());
require('./config/db');


app.get('/', (req, res) => {
  res.send("Node server is running.");
});


io.on('connection', (socket) => {
  console.log("connected!");

  //CLEAR DB
  socket.on("onClearDB", async () => {
    try {
      const user = await User.deleteMany();
      console.log(user);
    } catch (e) {
      console.log(e);
    }
  });

  //update engaged status
  socket.on("onUpdateEngagedStatus", async (id) => {
    try {
      const currentUser = await User.findById(id).select({ password: 0, __v: 0 });
      if (currentUser != null) {
        currentUser.isEngaged = !currentUser.isEngaged;
        const info = await User.findByIdAndUpdate(id, currentUser, { new: true }).select({ password: 0, __v: 0 });
        console.log(`user engaged ${info}`);
        socket.emit("onUpdateEngagedStatusSuccessListener", info);

      } else {
        socket.emit("errorOccurred", "User not found.");
      }

    } catch (e) {
      console.log(e);
    }
  });

  //JOIN ROOM
  socket.on("onJoinRoom", (roomId) => {
    if (roomId != null) {
      socket.join(roomId);
      console.log("join to message channel success");
    } else {
      console.log('Cannot join to message channel');
    }

  });

  //LEAVE CONVERSATION
  socket.on("onLeaveConversation", async ({ senderId, receiverId }) => {
    try {
      const currentUser = await User.findById(senderId).select({ password: 0, __v: 0 });
      if (currentUser != null) {
        io.to(senderId).emit("onLeaveConversationSuccessListener", "leave conversation");
        io.to(receiverId).emit("onLeaveConversationNotifyListener", "leave conversation");
      } else {
        socket.emit("errorOccurred", "User not found.");
      }
    }
    catch (e) {
      console.log(e);
    }

  });

  //LOGIN
  socket.on("onLoginUser", async ({ email, password }) => {
    try {
      const user = await User.findOne({ email: email }).select({ __v: 0 });

      if (user != null) {
        //match password
        const match = password == user.password
        if (!match) {
          socket.emit("errorOccurred", "Password don't match!.");
        } else {
          //login success
          //check already login or not
          if (user.isActive == true) {
            console.log("user is already logged in");
            socket.emit("errorOccurred", "User is already logged in!.");
          } else {
            user.isEngaged = false;
            user.isActive = true;

            const currentUser = await User.findOneAndUpdate({ email: email }, user, { new: true }).select({ password: 0, __v: 0 });

            console.log("onLoginUserNew " + currentUser);
            if (currentUser != null) {
              socket.emit("onLoginSuccess", currentUser);
              io.emit("onNewLoginUserListener", currentUser);
            } else {
              socket.emit("errorOccurred", "User not found.");
            }
          }

        }
      } else {
        socket.emit("errorOccurred", "User not registered.");
      }

    } catch (e) {
      console.log(e);
    }
  });


  //LOGOUT
  socket.on("onLogoutUser", async (id) => {
    try {
      const user = await User.findById(id).select({ __v: 0 });
      if (user != null) {
        user.isEngaged = false;
        user.isActive = false;

        const currentUser = await User.findOneAndUpdate({ _id: id }, user, { new: true }).select({ password: 0, __v: 0 });
        console.log("onLogoutUser " + currentUser);

        if (currentUser != null) {
          io.emit("onLogoutSuccess", currentUser);

        } else {
          socket.emit("errorOccurred", "User not found.");
        }
      } else {
        socket.emit("errorOccurred", "User not registered.");
      }

    } catch (e) {
      console.log(e);
    }
  });


  //ACTIVE USER
  socket.on("onFetchActiveUser", async (id) => {
    try {
      console.log("onFetchActiveUser ");

      const currentUser = await User.findById(id).select({ password: 0, __v: 0 });
      if (currentUser != null) {
        const activeUser = await User
          .find({ $and: [{ _id: { $ne: id } }, { isActive: true }] })
          .select({ password: 0, __v: 0 });
        if (activeUser != null) {
          socket.emit("onActiveUserListener", activeUser);
        }

      } else {
        socket.emit("errorOccurred", "User not found.");
      }
    } catch (e) {
      console.log(e);
    }
  });

  //REGISTRATION
  socket.on("onRegisterUser", async ({ name, email, password }) => {
    try {
      //check already exist or not
      const found = await User.findOne({ email: email });
      console.log("onRegisterUser " + found);
      if (found != null) {
        console.log('user already exist');
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
      console.log('error ' + e);
    }
  });



  //REQUEST SENT
  socket.on("onRequestSent", async ({ senderId, receiverId }) => {
    try {
      //verify sender exist
      const sender = await User.findById(senderId).select({ password: 0, __v: 0 });
      if (sender != null) {
        const receiver = await User.findById(receiverId).select({ password: 0, __v: 0 });
        if (receiver != null && !receiver.isEngaged) {
          socket.emit("onRequestSentSuccess", "request sent success");
          //broadcast to receiver
          io.to(receiverId).emit("onUserRequestListener", sender);
        } else {
          socket.emit("userBusy", "User is not available!");
        }

      } else {
        socket.emit("errorOccurred", "User not found");

      }

    } catch (e) {
      console.log(e);
    }
  });

  //REQUEST ACCEPT
  socket.on("onRequestAccept", async ({ senderId, receiverId }) => {
    try {
      //verify sender exist
      const sender = await User.findById(senderId).select({ password: 0, __v: 0 });
      const receiver = await User.findById(receiverId).select({ password: 0, __v: 0 });
      if (sender != null && receiver != null) {
        io.to(senderId).emit("onRequestAcceptSuccess", receiver);
      } else {
        socket.emit("userBusy", "User is not available!");
      }
    } catch (e) {
      console.log(e);
    }
  });

  //REQUEST Pending
  socket.on("onRequestPending", async ({ senderId, receiverId }) => {
    try {
      //verify sender exist
      const sender = await User.findById(senderId).select({ password: 0, __v: 0 });
      const receiver = await User.findById(receiverId).select({ password: 0, __v: 0 });
      if (sender != null && receiver != null) {
        //broadcast to sender and receiver
        io.to(senderId).emit("onRequestPendingListener", receiver);
      } else {
        socket.emit("errorOccurred", "User not found");
      }

    } catch (e) {
      console.log(e);
    }
  });



  //LEAVE SOCKET
  socket.on("leaveSocket", (id) => {
    console.log('leave socket');
    socket.leave(id);
  });

  //Send message to only a particular user
  socket.on("onSendMessage", ({ senderId, receiverId, message }) => {

    const content = Message(
      {
        text: message,
        senderID: senderId,
      });

    console.log("message content " + content);

    io.to(senderId).emit("onMessageSentSuccess", content);
    io.to(receiverId).emit("onMessageReceiveSuccess", content);

  });
});


server.listen(port, () => {
  console.log(`server is running at http://127.0.0.1:${port}`)
})