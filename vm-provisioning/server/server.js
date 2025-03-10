const express = require("express");
const app = express()

app.use(express.json())


app.get("/start-instance" , async(req , res, next)=>{
	console.log("start instance");
	res.json({message : "prototype"})
})
app.listen(3000)
