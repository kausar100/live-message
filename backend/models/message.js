const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema(
    {
        text:{
            type: String,
        },
        senderSocketID:{
            type: String,
            required: true,
        },
        createdAt:{
            type: String,
            default: Date.now()
        },
    }
);

module.exports = messageSchema