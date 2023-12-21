const mongoose = require("mongoose");
const message = require('./message');

const channelSchema = new mongoose.Schema(
    {
        chatID: {
            type: String,
            required: true,
        },
        messages: [message],
        createdAt: {
            type: String,
            default: Date.now()
        },
    }
);

module.exports = mongoose.model("chatbox", channelSchema);