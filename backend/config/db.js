require("dotenv").config();

const mongoose = require("mongoose");

//connect to db
mongoose.connect(
    process.env.DB_URL
)
.then(()=>{
    console.log("successfully connect to mongodb atlas");
})
.catch(
    (error)=>{
        console.log("couldn't connect to db");
        console.log(error.message);
        process.exit(1);
    }
);


