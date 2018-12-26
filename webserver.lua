-- version 2 of webserver; accepts any GET var, displays
function init_webserver()
print("starting webserver"); 
srv=net.createServer(net.TCP);
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
    local buf= "<h1>ESP8266 Web Server</h1>";
    getVars(client,request)
    COMMAND=nil -- set command empty
    for k, v in pairs(DATA) do
        buf = buf.."<p>"..k.." : "..v.."</p>"
        if(k=="command") then -- command sent via url,
          COMMAND=v             -- so save it for later exec
        end  
   end
   client:send(buf);
   client:close();
   collectgarbage();
   if(COMMAND) then     -- if a command has been passed
      node.input(COMMAND)   -- do it.
   end   
    end)
end)
end
-- EXTRACT GET VARS
function getVars(client,request)
local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
if(method == nil)then
    _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
    end
if (vars ~= nil)then
    for k,v in string.gmatch(vars, '([^&=?]-)=([^&=?]+)' ) do
    -- for k, v in string.gmatch(vars, "(%w.+)=(%w.+)&*") do
        DATA[k] = v
        POSTED[k] = false
        print("k="..k..";v="..v)
        end
    end    
end 
-- STARTS HERE --
DATA={} -- GET key/value pairs received by web server OR console
tmr.alarm( 2 , 200 , 0 ,  function() init_webserver(); end)



