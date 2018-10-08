--[[
%% properties
%% events
32 CentralSceneEvent
34 CentralSceneEvent
%% globals
--]]

--variables
local buttonSource = fibaro:getSourceTrigger()["event"]["data"]
local deviceID = buttonSource["deviceId"]
local roomID = fibaro:getRoomID(deviceID)
local room = fibaro:getRoomName(roomID)
local message = 
'<IntegrationServiceMessage xmlns="http://Imatis.Fundamentum.IntegrationService.IntegrationServiceMessage"><Adapter>Fibaro</Adapter><Message><![CDATA[<message><RoomID>Room_ID</RoomID><SensorID>Light</SensorID><SensorValue>TemperatureID</SensorValue></message>]]></Message></IntegrationServiceMessage>'
local http = net.HTTPClient();
local alarmtype

--functions
function POST()
http:request('https://stadium.imatiscloud.com/Imatis/WebServices/External/IntegrationService/IntegrationService.svc/web/send',
{
  options = {
  method = 'POST',
  headers = {
  ['Authorization'] = 'Basic c3R1ZGVudDpzb21tZXJAMjAxOA==',
  ['Content-Type'] = 'application/xml',
  },
  data = message
},
success = function(current)
    if current.status == 200 then
        print('Data Receiving: ', current.status)
        print('CurrentData: ', current.data)
        fibaro:debug(json.encode(current))
        else
        fibaro:debug(current.status)
        end
    end
    })
end

--code
if (tostring(buttonSource["keyAttribute"]) == "Pressed") then
  alarmtype = 'OVERFALL'
elseif (tostring(buttonSource["keyAttribute"]) == "HeldDown") then
  alarmtype = 'OVERFALL'
elseif (tostring(buttonSource["keyAttribute"]) == "Pressed2") then
  alarmtype = 'HELSE'
end

message = string.gsub(message, "TemperatureID", alarmtype)
message = string.gsub(message, "Light", 'Alarm')
message = string.gsub(message, "Room_ID", room)
POST()



