-- UCGLIB SCREEN HANDLING FOR ILI9341
function init_display()
   -- Hardware SPI CLK=GPIO14 MOSI=GPIO13 MISO=GPIO12 (not used)
   -- CS, D/C, and RES can be assigned freely to available GPIOs
    local cs  = 8 -- GPIO15, pull-down 10k to GND
    local dc  = 4 -- GPIO2
    local res = 0 -- GPIO16
    spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
    -- initialize the matching driver for your display
    disp = ucg.ili9341_18x240x320_hw_spi(cs, dc, res)
     -- disp:begin(ucg.FONT_MODE_TRANSPARENT)
    disp:begin(ucg.FONT_MODE_SOLID)
    -- disp:setRotate180()
    disp:clearScreen()
    -- set up default colours white font black bg
    disp:setColor(0, 255, 255, 255)
    disp:setColor(1, 0, 0, 0)
    disp:setPrintDir(0)
end
-- ------ SCREEN DISPLAY HANDLER -----------
-- fonts in current ucg config: helvBxx_hr:08,10,12,18
--       ncenR12_tr,ncenR14_hr,ncenB24_tr,7x13B_tr
function dprint(font_index,content)
   if      (font_index==2) then
    disp:setFont(ucg.font_helvB18_hr)
   else -- default 
    font_index=1  
    disp:setFont(ucg.font_helvB12_hr)
    -- disp:setFont(ucg.font_helvB12_hr)
   end
  --local slen=disp:drawString(Scrxpos, Scrypos,0,content)
  -- increment screen x position
  --Scrxpos=Scrxpos+slen
  disp:setPrintPos(Scrxpos,Scrypos)
  disp:print(content)
  Scrxpos=Scrxpos+(content:len()*((font_index+1)*6))
  if(Scrxpos>320) then Scrxpos=10 end
end
--    ==================================================
function dprintl(font_index,content)
dprint(font_index,content)
local spacer=(6*(font_index+2))+10 -- calc y spacing to next line
Scrypos=Scrypos+spacer
Scrxpos=10
if(Scrypos>240) then Scrypos=10 end
end
