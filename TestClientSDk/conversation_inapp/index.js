'use strict';

const status = require("statuses")

const express = require("express")
const axios = require("axios")
const localtunnel = require("localtunnel")

const app = express()

app.use(express.json())

const apiKey = "aa243601"
const apiSec = "5kRuupsyevNjaKyy"
const appID = "ce903e93-a298-4ee2-8a4a-818ef582f1cb"
const appName = "App to App Chat Tutorial"

const tunnelURL = async () => {
    const res = await localtunnel(5002)
    console.log(res.url)
    return res.url
}

app.get("/", (request, response) => {
    console.log(request.body)
    response.send({ status: 200 })
})

app.get("/phone/call/answer", (req, res) => {
    console.log("received Call from answr endpoint with: ", req.body)
    res.send( [
        {
            "action": "talk",
            "text": "Welcome to a Vonage moderated conference. We will connect you when an agent is available",
            "voiceName": "Amy"
          }
          , { 
            "action": "connect",
            "from": '441143597002',
            "endpoint": [ 
              { "type": "phone", "number": req.query.to } 
            ]
          }
        // , { 
        //     "action": "connect",
        //     "from": req.query.from, 
        //     "endpoint": [ 
        //       { "type": "app", "user": "Alice" } 
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
          }, { 
            "action": "connect",
            "from": '441143597002',
            "endpoint": [ 
              { "type": "phone", "number": req.query.to } 
            ]
          }
    ])
})

app.get("/phone/call/event", (req, res) => {
    console.log("received Call from event endpoint with: ", req.body)
    res.send( {status: 200})
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
        console.log(`there is some error: ${error.response.data}`)
        throw error
    })
    console.log(data, status)
}
updateApplication()
app.post("/event", (req, res) => {
    console.log(req.body)
    res.send({
        status: 200
    })
})

app.get("/close", (req, res) => {
    console.log("Exiting NodeJS server");
    process.exit();
})

app.listen(5002, async () => {
    console.log("listening")
})