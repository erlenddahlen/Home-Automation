--declarations
TIME_BEFORE_RESTORE_LISTENING = 5000
READ_TIMEOUT = 50000


--variables
local selfId = fibaro:getSelfId()
--local a, b, c, counter, mac, signal, msg
local format = '  No: %d   MAC: %s   Signal: %d dBm'
local ip = fibaro:getValue(selfId, 'IPAddress')
local port = fibaro:getValue(selfId, 'TCPPort')
local room = "10A"
local message = 
'<IntegrationServiceMessage xmlns="http://Imatis.Fundamentum.IntegrationService.IntegrationServiceMessage"><Adapter>Fibaro</Adapter><Message><![CDATA[<message><RoomID>Room_ID</RoomID><SensorID>Temperature</SensorID><SensorValue>TemperatureID</SensorValue></message>]]></Message></IntegrationServiceMessage>'

--initiate
socket = Net.FUdpSocket(ip, port);
socket:setReadTimeout(READ_TIMEOUT);


--functions
function checkMAC(MAC)
    if MAC == 'B4:99:4C:5A:AE:D0' or MAC == 'EA:4B:6A:14:04:12' or MAC == '67:BE:C0:83:2B:AF' then
        return true
    end
end


function dataHandling(tempdata)
    local a, b, c = tempdata:match('(....)(............)(..)')
    local cnt = tonumber(decode(a, ''), 16)
    local mac = decode(b, ':')
    local sgl = twoComplementHexToDec(c)
    return cnt, mac, sgl
end


function decode(text, joinChar)
    local list = {}
    local index = 1
    while index <= string.len(text)-1 do
        table.insert(list, string.sub(text, index, index+1))
        index=index+2
    end
    reverse(list)
    return table.concat(list, joinChar)
end

function reverse(templist)
    local i = 1
    local j = table.getn(templist)
    while i < j do
        templist[i], templist[j] = templist[j], templist[i]
        i = i + 1
        j = j - 1
    end
end

function twoComplementHexToDec(hex)
    local v = tonumber(hex, 16)
    if v >= 128 then 
        return (v - 256)
    else 
        return v
    end
end



--main loop

while true do
    local data = socket:read()
    local dataLength = string.len(data)
    if dataLength > 0 then
        fibaro:debug('BLE device found')
        fibaro:debug('data: '..data)
        local counter, mac, signal = dataHandling(data)
        if checkMAC(mac) then
             fibaro:debug('true')
        end
        local msg = string.format(format, counter, mac, signal)
        fibaro:setGlobal('test', signal)
        fibaro:debug(msg)
        fibaro:sleep(TIME_BEFORE_RESTORE_LISTENING)
        --fibaro:debug('running')
    else
        fibaro:debug('No BLE devices')
        fibaro:sleep(TIME_BEFORE_RESTORE_LISTENING)
    end
end






