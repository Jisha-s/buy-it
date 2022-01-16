const express = require("express");
const cors = require("cors");
const app = express();
const port = 5000;
const db = require("./db/core");
const {
  generateHash,
  verifyPassword
} = require("./hash");
const {sendOtp} = require("./otpMobile");
const { generateToken ,verifyToken} = require('./jwt.js');
const short = require('short-uuid');
const fileUpload = require('express-fileupload');

app.use(cors());
app.use(express.json());
app.use(fileUpload());

app.use("/images", express.static("images"));

const authentication = (req,res,next)=>{

  if(!verifyToken(req.headers.authorization)){
    res.sendStatus(401);
    return;
  }
  req.userName=verifyToken(req.headers.authorization).username 
  next();

}

  
app.post('/api/v1/signup', async(req, res) => {
    const {name,userName,email,phone,password} = req.body;
    
    if(!name || !userName || !email || !password || phone.length !== 10 || !Number(phone)){
      res.send({status: false, data: "Required fields are empty"});
      return;
    }
  
    // const existingPhone = await db.selectData("users",{
    //     fields: [],
    //     filteringConditions: [["phone","=",phone]]
    // });
    
    // if(existingPhone.length){
    //   res.send({status: false, data: "Phone number already Exists"});
    //   return;
    // }
  
    const hashedPassword = await generateHash(password);
    const insertedId = await db.insertData("users",{
      name,
      userName,
      email,
      phone,
      password : hashedPassword
    });

    if(!insertedId){
      res.send({status: false, data: "Failed to add User"});
      return;
    }
  
    const otpResponce = await sendOtp(phone);
  
    if(!otpResponce.status){
      res.send({status: false, data: "Failed to sent otp"});
      return;
    }
    const insertedOtpId = await db.insertData("otps",{
      otp: otpResponce.otp,
      phone
      }
    );
  
    if(!insertedOtpId){
      res.send({status: false, data: "Failed to add User"});
      return;
    }
    res.send({status: true, data: "Signup Succsess"});
  
});

app.post("/api/v1/signup/otp-verification",async(req,res)=>{
  const {phone,otp} = req.body;
  const otpData = await db.selectData("otps",{
    fields: [],
    filteringConditions: [
    ["phone","=",phone]
    ]
  });

  if(!otpData.length){
    res.send({status: false, data: "Otp does not exists"});
    return;
  }
  
  if(otpData[otpData.length - 1].otp != otp){
    res.send({status: false, data: "Wrong Otp"});
    return;
  }
  // await db.updateData("users",
  //   { fields:[]
  //   , filteringConditions: [
  //       ["phone","=",phone]
  //     ] 
  //   }
  // );

  res.send({status: true, data: "Otp verified"});

});

app.post('/api/v1/login', async(req, res) => {
  const{userName,password} = req.body;

  const User = await db.selectData("users",{
    fields: [], 
    filteringConditions: [
      ["userName","=",userName]
    ]
  });
  if(!User.length){
    res.send({status: false, data: "User does not exists"});
    return;
  }

  const passwordMatch = await verifyPassword(password,User[0].password);

  if(!passwordMatch){
    res.send({status: false, data: "Wrong Password"});
    return;
  }
  res.send({status: true, token: generateToken(userName)});
});

app.post("/api/v1/forgotpassword",async(req,res)=>{
  const{phone} = req.body;

  const phoneData = await db.selectData("users",{
    fields: [],
    filteringConditions: [
    ["phone","=",phone]
    ]
  }
  );
 
  if(!phoneData.length){
    res.send({status: false, data: "NO phone number exist"});
    return;
  }

  const otpResponce = await sendOtp(phone);

  if(!otpResponce.status){
    res.send({status: false, data: "Failed to sent otp"});
    return;
  }
  const insertedOtpId = await db.insertData("otps",{
    otp: otpResponce.otp,
    phone
    }
  );

  if(!insertedOtpId){
    res.send({status: false, data: "Failed to connect to db"});
    return;
  }
    res.send({status: true, data: " Succsess"});

});
  
app.post("/api/v1/forgotpassword/otp-verification",async(req,res)=>{
  const {phone,otp} = req.body;
  const otpData = await db.selectData("otps",{
    fields: [],
    filteringConditions: [
    ["phone","=",phone]
    ]
  }
  );
  

  if(!otpData.length){
    res.send({status: false, data: "Otp does not exists"});
    return;
  }
  
  if(otpData[otpData.length - 1].otp != otp){
    res.send({status: false, data: "Wrong Otp"});
    return;
  }
  res.send({status: true, token: generateToken(phone)});

});

app.post("/api/v1/forgotpassword/password-reset",authentication,async(req,res)=>{
  const{phone,password} = req.body;
  const hashedPassword = await generateHash(password);

  await db.updateData("users",
    { fields: { password: hashedPassword
      }, filteringConditions: [
      ["phone","=",phone]
    ] 
  });

 res.send({status: true, data: " Password updated successfully!"});

});

app.post("/api/v1/product", async(req, res) => {
    const {pname,userName,price,quantity,category,description,url,rating} = req.body;
    const insertedId = await db.insertData("products",{
      pname,
      userName,
      price,
      quantity,
      category,
      description,
      // imageId :url,
      rating
    });

    if(!insertedId){
      res.send({status: false, data: "Failed to add product"});
      return;
    }
    res.send({status:true,data:"product added successfully!!",token: generateToken(userName)});

});


app.post('/api/v1/upload',authentication,async(req, res) => {

  if (!req.files || Object.keys(req.files).length === 0) {
    return res.status(400).send('No files were uploaded.');
  }
  const {image} = req.files;
  const uploadPath = '/images/' +short.generate() + ".jpg";

  image.mv(__dirname + uploadPath, (err) =>{
    if (err)
      return res.status(500).send(err);

    res.send({status: true, data:{url: uploadPath}});
    
  });
   
});


app.post("/api/v1/createOrder",async(req,res) => {

  const{userName,phone,pname,quantity,total,address} = req.body;
  
  const insertData = await db.insertData("orders",{
    userName,
    phone,
    pname,
    quantity,
    total,
    address
  
  });

  if(!insertData){
    res.send({status: false, data: "Failed to create order!!"});
    return;
  }
  res.send({status:true,data:"order created successfully!!",
  token: generateToken(phone)});

});

app.post("/api/v1/Order-cancel",authentication ,async(req,res) => {

  const {orderid}= req.body;
  const deleteData = db.deleteData("orders",{fields:[],
  filteringConditions:[
    ["orderid","=",orderid]
  ]});
 
  if(!deleteData){
    res.send({status: false, data: "Failed to cancel order!!"});
    return;
  }
  res.send({status:true,data:"order cancelled sucessfully!!"})

});

app.post("/api/v1/product/delete",authentication ,async(req,res) => {

  const {pid}= req.body;
  const deleteData = db.deleteData("products",{fields:[],
  filteringConditions:[
    ["pid","=",pid]
  ]});
 
  if(!deleteData){
    res.send({status: false, data: "Failed to delete product!!"});
    return;
  }
  res.send({status:true,data:"product deleted sucessfully!!"})

});


app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});