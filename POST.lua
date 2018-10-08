local message = '<IntegrationServiceMessage xmlns="http://Imatis.Fundamentum.IntegrationService.IntegrationServiceMessage"><Adapter>Minimal</Adapter><Message><![CDATA[<message><subject>MySubject</subject><body>MyBody</body></message>]]></Message></IntegrationServiceMessage>'
local http = net.HTTPClient();
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