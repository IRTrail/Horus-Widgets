-- Heli flight pack battery widget V0.2
--[[ To do:
      get display to conform to widget size
      maybe add some more info or graphics or bitmaps to make it look better
      ]]
      
  -- Many thanks to DanielGA on Helifreak, who is immensely helpful!
	-- Thanks to IShems and everyone else at RCGroups who answered my questions.
	-- Thanks to all the other coders before me who's code I studied, egregiously pilfered, and changed to make this work.

local options = {
  { "Sensor", SOURCE }, -- get a sensor
  { "BattSize", VALUE, 35 } -- set battery size to 3500 default
}
-- Do some zone stuff. 
local function create(zone, options)
  local myZone = { zone=zone, options=options}
  local capRem = 0
  local capUsed = Sensor
  local capTotal = BattSize
  
  return myZone
end
-- update options if necessary
local function update(myZone, options)
  myZone.options = options
end

---------------------------------------------------------------------------
--             this section contains auxillary functions                 --
---------------------------------------------------------------------------

--Function to calculate remaining percentage.
    --Funky math is to allow BattSize reported in actual mAh
local function calc(sensor, total)
  capRem = math.floor( 100 -( sensor * 100 / total )) -- remaining capacity normalized to pectentage
return capRem
end

-- This function returns green red below 10%, yellow in between, and green above 25%
local function getPercentColor(cpercent)
  if cpercent < 10 then
    return lcd.RGB(0xff, 0x33, 0x33)
  elseif cpercent < 25 then
    return lcd.RGB(0xff, 0xff, 0)
  else
    return lcd.RGB(0,0xff,0)
  end
end
-- Play percent remaining voice calls
    -- plays percent at intervals of 10 above 10% and each 5% at intervals below 10%
local function bitchAboutIt()
	local pct
-- set up interval
	if capRem < 10 then
		pct = capRem % 5
	else
		pct = capRem % 10
	end
-- bitch about it.
	if pct == 0 and capRem ~= trip and capRem > 0 and capRem < 100 then
		playNumber(capRem, 13)
			trip = capRem	-- don't keep bitching about it.
  end
end
---------------------------------------------------------------------------
--             this section contains zone draw functions                 --
---------------------------------------------------------------------------
-- Top bar, Size: 70x39 (Tiny)
local function zoneTiny(zone)
  local capUsed = getValue(zone.options.Sensor)
  local capTotal = zone.options.BattSize * 100
  local capRem  = calc(capUsed, capTotal)
  
  lcd.drawText(zone.zone.x+0, zone.zone.y+0, capUsed .. "mAh", TEXT_INVERTED_COLOR + SMLSIZE)
  --lcd.drawText(zone.zone.x+0, zone.zone.y+12, capTotal .. "mAh", TEXT_INVERTED_COLOR + SMLSIZE)
  lcd.setColor(CUSTOM_COLOR, getPercentColor(capRem))
  lcd.drawGauge(zone.zone.x+0, zone.zone.y+28, 68, 12, capRem, 100, CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+20, zone.zone.y+25, capRem.."%", TEXT_INVERTED_COLOR + SHADOWED + SMLSIZE)
end

-- Small, Size: 160x32 (1/8)
local function zoneSmall(zone)
  local capUsed = getValue(zone.options.Sensor)
  local capTotal = zone.options.BattSize * 100
  local capRem  = calc(capUsed, capTotal)
  
  lcd.drawText(zone.zone.x+2, zone.zone.y+0, capUsed .. " mAh / " .. capTotal .. " total", TEXT_INVERTED_COLOR + SMLSIZE) --report capacity 
  lcd.setColor(CUSTOM_COLOR, getPercentColor(capRem))
  lcd.drawGauge(zone.zone.x+0, zone.zone.y+20, 160, 12, capRem, 100, CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+60, zone.zone.y+16, capRem.."%", TEXT_INVERTED_COLOR + SHADOWED + SMLSIZE)
end
-- Medium, Size: 180x70 (1/4)
local function zoneMedium(zone)
  local capUsed = getValue(zone.options.Sensor)
  local capTotal = zone.options.BattSize * 100
  local capRem  = calc(capUsed, capTotal)
  
  lcd.setColor(CUSTOM_COLOR, WHITE)
  lcd.drawText(zone.zone.x+2, zone.zone.y+0, "Remaining:", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+100, zone.zone.y+0, capRem .. "%", CUSTOM_COLOR) --report percent
  lcd.drawText(zone.zone.x+2, zone.zone.y+16, "Used: " .. capUsed .. "mAh", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+32, "Total: " .. capTotal .. "mAh", CUSTOM_COLOR)
  lcd.setColor(CUSTOM_COLOR, getPercentColor(capRem))
  lcd.drawGauge(zone.zone.x+0, zone.zone.y+50, 180, 20, capRem, 100, CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+75, zone.zone.y+50, capRem.."%", TEXT_INVERTED_COLOR + SHADOWED)
end

-- Large, Size: 192x152 (half)
local function zoneLarge(zone)
  local capUsed = getValue(zone.options.Sensor)
  local capTotal = zone.options.BattSize * 100
  local capRem  = calc(capUsed, capTotal)
    
  lcd.drawText(zone.zone.x+2, zone.zone.y+0, "Battery", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+16, "Remaining:", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+100, zone.zone.y+0, capRem .. "%", CUSTOM_COLOR + DBLSIZE) --report percent
  lcd.drawText(zone.zone.x+2, zone.zone.y+40, "Capacity Used:" , CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+56, capUsed .. "mAh", CUSTOM_COLOR) --report capacity used
  lcd.drawText(zone.zone.x+2, zone.zone.y+80, "Usable Battery:", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+96, capTotal .. "mAh", CUSTOM_COLOR) -- report usable size set in options
  lcd.setColor(CUSTOM_COLOR, getPercentColor(capRem))
  lcd.drawGauge(zone.zone.x+0, zone.zone.y+130, 190, 20, capRem, 100, CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+75, zone.zone.y+130, capRem.."%", TEXT_INVERTED_COLOR + SHADOWED)
end
-- XLarge, Size: 390x172 (full)
local function zoneXLarge(zone)
  local capUsed = getValue(zone.options.Sensor)
  local capTotal = zone.options.BattSize * 100
  local capRem  = calc(capUsed, capTotal)
    
  lcd.drawText(zone.zone.x+2, zone.zone.y+0, "Battery", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+16, "Remaining:", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+100, zone.zone.y+0, capRem .. "%", CUSTOM_COLOR + DBLSIZE) --report percent
  lcd.drawText(zone.zone.x+2, zone.zone.y+40, "Capacity Used:" , CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+56, capUsed .. "mAh", CUSTOM_COLOR) --report capacity used
  lcd.drawText(zone.zone.x+2, zone.zone.y+80, "Usable Battery:", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+96, capTotal .. "mAh", CUSTOM_COLOR) -- report usable size set in options
  lcd.setColor(CUSTOM_COLOR, getPercentColor(capRem))
  lcd.drawGauge(zone.zone.x+2, zone.zone.y+150, 190, 20, capRem, 100, CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+75, zone.zone.y+150, capRem.."%", TEXT_INVERTED_COLOR + SHADOWED)
end
-- hope to impliment playValue here as well as refresh() to call percents when widget isn't visible
-- not working right now for some reason...?
local function background(myZone)
  if getRSSI() > 0 then -- play percent if telemetry is linked up
    bitchAboutIt()
  end
end
-- Draw the values and stuff while the screen is visible.
function refresh(myZone)
  
  if getRSSI() > 0 then -- play percent if telemetry is linked up
    bitchAboutIt()
  end
  
  if        myZone.zone.w  > 380 and myZone.zone.h > 165 then zoneXLarge(myZone)
    elseif  myZone.zone.w  > 180 and myZone.zone.h > 145  then zoneLarge(myZone)
    elseif  myZone.zone.w  > 170 and myZone.zone.h > 65 then zoneMedium(myZone)
    elseif  myZone.zone.w  > 150 and myZone.zone.h > 28 then zoneSmall(myZone)
    elseif  myZone.zone.w  > 65 and myZone.zone.h > 35 then zoneTiny(myZone)
  end
end

return { name="PwrPanel", options=options, create=create, update=update, refresh=refresh, background=background }
