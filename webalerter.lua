-- version 2 of webserver; accepts any GET var, displays
function init_webserver()
PAGETITLE="MESSAGES"
dofile("screen.lua")
init_display() -- set up display screen ready to show data
-- refresh screen every 10 secs
-- tmr.alarm( 2 , 10000 , 1 ,  function() display_data(); end)
print("starting webserver") 
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
    local buf= "<h1>"..PAGETITLE.."</h1>"
    getVars(client,request)
    for k, v in pairs(_GET) do
		buf = buf.."<p>"..k.." : "..v.."</p>"
    end
   print("buffer="..buf) 
   client:send(buf)
   collectgarbage()
   display_data()
   closeTimer:alarm(initTimeout,tmr.ALARM_SINGLE,function() client:close() end)
   end)     -- end receive
end)        -- end listen
end
--   UPDATE SCREEN WITH DATA
function display_data()
Scrxpos=10 -- current position on screen - x coordinate
Scrypos=20 -- current position on screen - y coordinate
disp:setColor(255, 168, 0)
dprintl(2,PAGETITLE)
dprintl(2,"")
disp:setColor(20, 240, 240)
  for k, v in pairs(_GET) do
     dprint(2,k.." : "..v)
     dprintl(2,"")
  end
end
--    ==================================================
-- EXTRACT GET VARS FROM WEB REQUEST
function getVars(client,request)
local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
    if(method == nil)then
    _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
    end
    if (vars ~= nil)then
    for k,v in string.gmatch(vars, '([^&=?]-)=([^&=?]+)' ) do
    -- for k, v in string.gmatch(vars, "(%w.+)=(%w.+)&*") do
        _GET[k] = v
        print("k="..k..";v="..v)
        end
    end    
end 

-- STARTS HERE --
print("webalerter started")
_GET={} -- GET params received by web server OR 
require("WifiConnect")
wifiTrys     = 0      -- reset counter of trys to connect to wifi
NUMWIFITRYS  = 20    -- Maximum number of WIFI Testings while waiting for connection
initTimeout=2000       -- // timer in ms
closeTimer=tmr.create()  -- // delay before close
initTimer:alarm(initTimeout,tmr.ALARM_SINGLE,function() checkConnection(init_webserver) end) 
