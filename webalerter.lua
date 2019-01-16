-- version 2 of webserver; accepts any GET var, displays
function init_webserver()
PAGETITLE="ESP8266 Web Server"
dofile("screen.lua")
init_display() -- set up display screen ready to show data
-- refresh screen every 10 secs
tmr.alarm( 2 , 10000 , 1 ,  function() display_data(); end)
print("starting webserver") 
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
    local buf= "<h1>"..PAGETITLE.."</h1>"
    getVars(client,request)
    for k, v in pairs(_GET) do
    -- see if received url args have matching ts field # 
	if FX[k]~=nil then -- if field in field index table, display it
		buf = buf.."<p>"..k.." : "..v.."</p>"
	end	
   end
   client:send(buf)
   client:close()
   collectgarbage()
   end)
end)
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

function checkConn()    -- wait for internet
 if(CONNECTED) then
    tmr.stop(2)
    require("ide") -- once connected, start server
 else
    tmr.alarm( 2, 2000, 0, checkConn)
 end
end

-- STARTS HERE --
_GET={} -- GET params received by web server OR console
tmr.alarm( 1 , 3000, 0 , function() require("connectIP") end )
tmr.alarm( 2 , 5000, 0 , checkConn )
tmr.alarm( 2 , 800 , 0 ,  function() init_webserver(); end)
  