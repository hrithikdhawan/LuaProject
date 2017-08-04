require("constants") 
--setup wifi
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWORD)
-- connect to MQTT broker if inernet connected
tmr.alarm(0,5000,tmr.ALARM_SINGLE,
function()
local myip=wifi.sta.getip()
if myip~=nil then
	print(myip)
	connectToMQTT()
else print("internet not working")
end
end)

-- it reads temperature from dht22 sensor every 30s
function readTemperature()
local pin=2
tmr.alarm(0,30000,tmr.ALARM_AUTO,
function()
local state,temp=dht.read(pin)  --others ignored
if state==dht.OK then
sendDataToMQTT(temp)
else print("sensor not working")
keepAlive() --doubt
end
end)
end

-- publish temperature data to MQTT
function sendDataToMQTT(temp)
myClient:publish(ENDPOINT_SENSOR,temp,0,0,
function(client)
print("data successfully sent")
end)
end


function keepAlive()
tmr.alarm(1,10000,tmr.ALARM_AUTO,function()
myClient:publish("sensor_alive","sesnor is alive",0,0,
function(client)
print("alive")
end)
end)
end


-- connecting to mQTT broker and handling all the events
function connectToMQTT()
myClient=mqtt.Client(USERID1,120,"user1","hellomqtt") --global mqtt client
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
readTemperature()
end)

myClient:on("offline",
function(client)
print("MQTT offline")
end)

myClient:on("message",
function(client,topic,message)
if message~=nil then
print("topic : "..topic.." message : "..message) 
end
end)
end
