const mongoose = require("mongoose");

const personSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
        },
        email: {
            type: String,
            required: true,
        },
        password: {
            type: String,
            required: true,
        },
        socketID: {
            type: String,
            required: true
        },
        chatID: {
            type: String,
            default: null,
        },
        isActive: {
            type: Boolean,
            default: true
        },
        isEngaged: {
            type: Boolean,
            default: false
        },
        createdAt: {
            type: String,
            default: Date.now()
        },
    }
);

module.exports = mongoose.model("person", personSchema);