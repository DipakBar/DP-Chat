const express=require('express');
const app=express();
const PORT=process.env.PORT || 5000;
const server=app.listen(PORT,()=>{console.log('server started on',PORT)});
const io=require('socket.io')(server);
app.use(express.json());
var clints={};


io.on('connection', (socket)=>{
    console.log('connected successfully',socket.id);
    socket.on('signin',(id)=>{
        console.log('id',id);
        clints[id]=socket;
        console.log(clints);
    });
    socket.on('disconnected',(_)=>{
        console.log('disconnected',socket.id);
    });
socket.on('message',(data)=>{ 
console.log(data);
let tergetid=data.reciverid;
if(clints[tergetid])
clints[tergetid].emit('message-recived',data);
// socket.broadcast.emit('message-recived',data);
});
});
