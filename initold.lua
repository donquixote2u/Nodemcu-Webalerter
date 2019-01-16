-- telnet console 
--manifest: screen.lua,connectIP.lua, ide.lua, wificredentials.lua
-- todo: convert timers to locally defined (general timers deprecated)
 -- Constants
 require_once("wificredentials")
-- Some control variables
wifiTrys     = 0      -- Counter of trys to connect to wifi
NUMWIFITRYS  = 200    -- Maximum number of WIFI Testings while waiting for connection
function checkConn()    -- wait for internet
 if(CONNECTED) then
    tmr.stop(2)
    require("ide") -- once connected, start server
 else
    tmr.alarm( 2, 2000, 0, checkConn)
 end
end
tmr.alarm( 1 , 3000, 0 , function() require("connectIP") end )
tmr.alarm( 2 , 5000, 0 , checkConn )
-- Drop through here to let NodeMcu run

