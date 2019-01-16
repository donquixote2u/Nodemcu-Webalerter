-- accept data via webserver GET, display on web and screen
--manifest: checkwifi.lua, screen.lua, webface.lua, webserverlua
--new manifest: screen.lua,connectIP.lua, ide.lua, wificredentials.lua
-- Constants
 require_once("wificredentials")
-- Some control variables
wifiTrys     = 0      -- Counter of trys to connect to wifi
NUMWIFITRYS  = 200    -- Maximum number of WIFI Testings while waiting for connection
tmr.alarm( 1 , 2500 , 0 , function() dofile("webalerter.lua") end )
-- Call main control pgm after timeout
-- Drop through here to let NodeMcu run

