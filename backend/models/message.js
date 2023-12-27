const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema(
    {
        text: {
            type: String,
        },
        senderID: {
            type: String,
            required: true,
        },
        createdAt: {
            type: String,
            default: Date.now().toLocaleString()
        },
    }
);

module.exports = mongoose.model("message", messageSchema)