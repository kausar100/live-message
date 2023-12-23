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

  //CLEAR DB
  socket.on("onClearDB", async () => {
    try {
      const user = await User.deleteMany();
      console.log(user);
      const db = await Room.deleteMany();
      console.log(db);

    } catch (e) {
      console.log(e);
    }
  });

  //JOIN ROOM
  socket.on("onJoinRoom", (roomId)=>{
    if(roomId!=null){
      socket.join(roomId);
      console.log("join to message channel success");
    }else{
      console.log('Cannot join to messag channel');
    }
    
  });

  //LOGIN
  socket.on("onLoginUser", async ({ email, password }) => {
    try {
      const user = await User.findOne({ email: email }).select({ __v: 0 });
      console.log("onLoginUser "+user);
      if (user != null) {
        //match password
        const match = password == user.password
        if (!match) {
          socket.emit("errorOccurred", "Password don't match!.");
        } else {
          //login success
          const currentUser = await User.findById(user._id).select({ password: 0, __v: 0 });
          if (currentUser != null) {
            socket.emit("onLoginSuccess", currentUser);
          } else {
            socket.emit("errorOccurred", "User not found.");
          }
        }

      } else {
        socket.emit("errorOccurred", "User not registered.");
      }

    } catch (e) {
      console.log(e);
    }
  });

  //ACTIVE USER
  socket.on("onFetchActiveUser", async ({ id }) => {
    try {
      console.log("onFetchActiveUser ");

      const currentUser = await User.findById(id).select({ password: 0, __v: 0 });
      if (currentUser != null) {
        const activeUser = await User.find({ _id: { $ne: id } }).select({ password: 0, __v: 0 });
        console.log("onFetchActiveUser "+activeUser);

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
      console.log("onRegisterUser "+found);
      if (found!=null) {
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
      console.log('rror '+e);
    }
  });



  //REQUEST SENT
  socket.on("onRequestSent", async ({senderId, receiverId})=>{
    try{
      //verify sender exist
      const sender = await User.findById(senderId).select({password:0,__v:0});
      if(sender!=null){
        const receiver = await User.findById(receiverId).select({password:0,__v:0});
        if(receiver!=null && !receiver.isEngaged){
          //create a chatId
          const chatBox = await Room().save();
          console.log('message channel '+chatBox);
          if(chatBox!=null){
            socket.emit("onRequestSentSuccess",chatBox._id); 
            //broadcast to receiver
            io.to(receiverId).emit("onUserRequestListener", {"chatID":chatBox._id, "sender":sender}); 
                    
          }else{
            socket.emit("errorOccurred", "Failed to generate create a channel");
          }

        }else{
          socket.emit("userBusy", "User is not available!");
        }

      }else{
        socket.emit("errorOccurred", "User not found");

      }

    }catch(e){
      console.log(e);
    }
  });

    //REQUEST ACCEPT
    socket.on("onRequestAccept", async ({senderId, receiverId, chatId})=>{
      try{
        //verify sender exist
        const sender = await User.findById(senderId).select({password:0,__v:0});
        if(sender!=null && !sender.isEngaged){
          const receiver = await User.findById(receiverId).select({password:0,__v:0});
          if(receiver!=null && !receiver.isEngaged){
              //broadcast to sender and receiver
              io.to(senderId).emit("onRequestAcceptSuccess", "Request accept successfully");
          }else{
            socket.emit("userBusy", "User is not available!");
          }
  
        }else{
          socket.emit("userBusy", "User is not available!");
        }
  
  
      }catch(e){
        console.log(e);
      }
    });

  //Leave the room if the user closes the socket
  // socket.on('disconnect', () => {
  //     socket.leave(chatID)
  // });

  //Send message to only a particular user
  socket.on('send_message', message => {
      receiverChatID = message.receiverChatID
      senderChatID = message.senderChatID
      content = message.content

      //Send message to only that particular room
      socket.in(receiverChatID).emit('receive_message', {
          'content': content,
          'senderChatID': senderChatID,
          'receiverChatID':receiverChatID,
      });
  });
});


server.listen(port, () => {
  console.log(`server is running at http://127.0.0.1:${port}`)
})