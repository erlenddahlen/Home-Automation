--[[
%% properties
7 value
29 value
%% globals
--]]

--variables
local trigger = fibaro:getSourceTrigger()
local deviceID = trigger['deviceID']
local roomID = fibaro:getRoomID(deviceID)
local room = fibaro:getRoomName(roomID)
local myVariable = fibaro:getValue(deviceID, 'value')
local message = '<IntegrationServiceMessage xmlns="http://Imatis.Fundamentum.IntegrationService.IntegrationServiceMessage"><Adapter>Fibaro</Adapter><Message><![CDATA[<message><RoomID>Room_ID</RoomID><SensorID>Alarm</SensorID><SensorValue>TemperatureID</SensorValue></message>]]></Message></IntegrationServiceMessage>'
local http = net.HTTPClient()

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
if (myVariable == 1) then
	message = string.gsub(message, "TemperatureID", 'RØYK')
	message = string.gsub(message, "Room_ID", room)
  POST()
end

	