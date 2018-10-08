--[[
%% properties
%% events
%% globals
--]]
local maxID = 200
local name
local room
local batteryLevel
local format = "  Navn: %s   Batteri: %s  "
local format2 = " %s%s \n"
local http = net.HTTPClient();
local msg
local bigmsg

local A10 = {}
local B10 = {}
--local roomTable = ['10A', '10B']

function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

function fillRooms()
  for id = 1, maxID do  
    room = fibaro:getRoomNameByDeviceID(id)
    if tostring(room) == '10A' then
      table.insert(A10, id)
    elseif tostring(room) == '10B' then 
      table.insert(B10, id)
    end
  end
end


function updateVisi(roomTable)
  bigmsg = ' -- ÅPNE --  \n'
  for v in values(roomTable) do
    room = fibaro:getRoomNameByDeviceID(v)
    name = fibaro:getName(v)
    batteryLevel = fibaro:get(v, 'batteryLevel')
    msg = string.format(format, name, batteryLevel)
    bigmsg = string.format(format2, bigmsg, msg )
  end
  POST(bigmsg, room)
end

function POST(msg, room)
local message = 
'<IntegrationServiceMessage xmlns="http://Imatis.Fundamentum.IntegrationService.IntegrationServiceMessage"><Adapter>Fibaro</Adapter><Message><![CDATA[<message><RoomID>Room_ID</RoomID><SensorID>Battery</SensorID><SensorValue>TemperatureID</SensorValue></message>]]></Message></IntegrationServiceMessage>'
message = string.gsub(message, "TemperatureID", msg)
message = string.gsub(message, "Room_ID", tostring(room))
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
fillRooms()

updateVisi(A10)
updateVisi(B10)


 