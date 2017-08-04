require("constants") 
--setup wifi
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWORD)

tmr.alarm(0,5000,tmr.ALARM_SINGLE,
function()
local myip=wifi.sta.getip()
if myip~=nil then
    print(myip)
    connectToMQTT()
else print("internet not working")
end
end)

function subscribeMQTT()
myClient:subscribe(ENDPOINT_SENSOR,0,
function(conm)
print("subscribed")
end)
end


function sendToThingSpeak(temperature)
print("sending to thingspeak")
--http.post('http://api.thingspeak.com/update','Content-Type : application/json\r\n','{"api_key":"EH3VEC8HKDM6GYN2","field1":'..temperature..'}')
http.post('https://api.thingspeak.com/update','Content-Type:application/json\r\n','{"api_key":"26VFAI7I1BCSOCKW","field1":'..temperature..'}',
 function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print("Done")
    end
  end)
end

-- connecting to mQTT broker and handling all the events
function connectToMQTT()
myClient=mqtt.Client(USERID2,120,"user1","hellomqtt") --global mqtt client
myClient:connect(HOST,PORT,0,0,
function(client)
print("connecting")
end,
function(client,reason)
print(reason)
end)

myClient:on("connect",
function(client)
print("connected to MQTT")
subscribeMQTT()
end)

myClient:on("offline",
function(client)
print(" MQTT offline")
end)

myClient:on("message",
function(client,topic,message)
if message~=nil then
print("topic : "..topic.." message : "..message)
if topic==ENDPOINT_SENSOR then
--local temperature=50
sendToThingSpeak(message)
end
end
end)
end
