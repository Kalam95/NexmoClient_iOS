'use strict';

const status = require("statuses")
const apis = require("./Apis")
const express = require("express")
const axios = require("axios")
const localtunnel = require("localtunnel")
const { exec } = require("child_process");
const { test } = require("media-typer");
const route = require("color-convert/route");
//conversation-api-function config-new -a a698c860 -s 6eb37419d0f6c497 -l 447418999066
const app = express()

app.use(express.json())

const CS_URL = `https://api.nexmo.com`;
const WS_URL = `https://ws.nexmo.com`;

let apiKey = "aa243601"
let apiSec = "5kRuupsyevNjaKyy"
let appID = "4fed3d7a-3f65-436d-87dd-7751394aa433"
let appName = "App to App Chat Tutorial"

const tunnelURL = async () => {
    const res = await localtunnel(5001)
    console.log(res.url)
    return res.url
}

app.get("/start", (request, response) => {
    console.log(request.body)
    response.send({ status: 200 })
})
app.post("/login", (req, res)=>{
    console.log(req.body)
    
    res.send("okey")
})
app.post("/setApp", (request, response) => {
    apiKey = request.body.apiKey
    apiSec = request.body.apiSec
    appID = request.body.appID
    appName = request.body.appName
    updateApplication()
    response.sendStatus(200)
})

app.get("/phone/call/answer", (req, res) => {
    console.log("n\n\n\n received Call from answr endpoint with: ", req.query,"\n\n\n")
    const isReceived = onlyNumbers(req.query.from)
    res.send( [
        {
            "action": "talk",
            "text": "Welcome to a Vonage moderated conference. We will connect you when an agent is available",
            "voiceName": "Amy"
          }
          , { 
            "action": "connect",
            "from": isReceived ? req.query.from : '441143597002',
            "endpoint": [ 
              {
                   "type": isReceived ? "app" : "phone", 
                   "number": isReceived ? "" : req.query.to,
                   "user": isReceived ? "newAlam" : ""
             } 
            ]
          }
        // , { 
        //     "action": "connect",
        //     "from": req.query.from, 
        //     "endpoint": [ 
        //       { "type": "app", "user": "newAlam" } 
        //     ]
        //   }
    ])
})

app.get("/phone/call/feeback", (req, res) => {
    console.log("received Call from feeback endpoint with: ", req.body)
    res.send( [
        {
            "action": "talk",
            "text": "its a feedback",
            "voiceName": "Amy"
          }
    ])
})

app.get("/phone/call/event", (req, res) => {
    console.log("received Call from event endpoint with: ", req.body)
    res.send( {status: 200})
})

app.post("/message/inbound", (req, response) => {
    console.log("inbound with: ", req.body)
    response.sendStatus(200)
})

app.post("/message/status", (req, response) => {
    console.log("status with: ", req.body)
    response.sendStatus(200)
})

const updateApplication = async () => {
    const url = await tunnelURL()
    const authentication = `Basic ${Buffer.from(apiKey + ":" + apiSec).toString("base64")}`
    const body = {
        name: appName,
        capabilities: {
            rtc: {
                webhooks: {
                    event_url: {
                        address: `${url}/event`,
                        http_method: "POST"
                    }
                }
            },
            voice: {
                webhooks: {
                    answer_url: {
                        address: `${url}/phone/call/answer`, // return NACCO
                        http_method: "GET"
                    },
                    fallback_answer_url: {
                        address: `${url}/phone/call/feeback`, // return NACCO
                        http_method: "GET"
                    },
                    event_url: {
                        address: `${url}/phone/call/event`, 
                        http_method: "GET"
                    }
                }
            },
            messages: {
                version: "v1",
                webhooks: {
                    inbound_url: {
                        address: `${url}/message/inbound`, 
                        http_method: "POST"
                    },
                    status_url: {
                        address: `${url}/message/status`,
                        http_method: "POST"
                    }
                }
            }
        }
    }
    const { data, status } = await axios({
        method: "PUT",
        url: `https://api.nexmo.com/v2/applications/${appID}`,
        data: body,
        headers: {
            Authorization: authentication
        }
    }).catch(error => {
        console.log(`there is some error: ${error} this is it`);
        throw error
    })
    console.log(data, status)
}
app.post("/event", (req, res) => {
    console.log(req.body)
    res.send( {
        status: 200})
    console.log("call request rtc")
})

app.post("/getJWT", (request, response) => {
    exec(`vonage jwt --app_id=${appID} --subject=USR-49b487d0-4ef0-4858-99d9-948cb2b3f336 --key_file=./app_to_app_chat_tutorial.key --acl='{"paths":{"/*/users/**":{},"/*/conversations/**":{},"/*/sessions/**":{},"/*/devices/**":{},"/*/image/**":{},"/*/media/**":{},"/*/applications/**":{},"/*/push/**":{},"/*/knocking/**":{},"/*/legs/**":{}}}'`, (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        response.send({
            jwt: stdout
        })
        console.log(`stdout: ${stdout}`);
    });
    console.log("Testing Variable", abc)
})
updateApplication()
function onlyNumbers(str) {
    if (str) {
        return /^[0-9]+$/.test(str)
    }
    return false
}
app.listen(5001, async () => {
    console.log("listening")
})