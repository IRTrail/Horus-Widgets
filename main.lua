-- (Not so) Feebile attempt to make a fuel percentage widget.
--[[ To do:
      get playValue working
      get display to conform to widget size
      maybe add some more info or graphics or bitmaps to make it look better
      ]]
      
  -- Many thanks to DanielGA on Helifreak, who is immensely helpful!

local options = {
  { "Sensor", SOURCE }, -- get a sensor
  { "BattSize", VALUE, 35 } -- set battery size to 3500 default
}
local pct = nil
local trip = false
-- Do some zone stuff. 
local function create(zone, options)
  local myZone = { zone=zone, options=options }
  local capRem = 0
  local capUsed = Sensor
  local capTotal = BattSize
  return myZone, capRem, capUsed, capTotal
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
capRem = math.floor( 100 -(sensor * 100 / total )) -- remaining capacity normalized to pectentage
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
-- Top bar (Tiny)
local function zoneTiny(zone)
  lcd.drawText(zone.zone.x, zone.zone.y, "XXX", CUSTOM_COLOR + BLINK + INVERS)
end

-- Small, Size: 160x30 (1/8)
local function zoneSmall(zone)
  lcd.drawText(zone.zone.x+8, zone.zone.y+8, "Please use Large size widget.", CUSTOM_COLOR + BLINK + INVERS)
end
-- Medium, Size: 180x70 (1/4)
local function zoneMedium(zone)
  lcd.drawText(zone.zone.x+12, zone.zone.y+12, "Please use Large size widget.", CUSTOM_COLOR + BLINK + INVERS)
end

-- Large, Size: 390x170 (half)
local function zoneLarge(zone)
  local capUsed = getValue(zone.options.Sensor)
  local capTotal = zone.options.BattSize * 100
  local capRem  = calc(capUsed, capTotal)
    
  lcd.drawText(zone.zone.x+2, zone.zone.y+0, "Battery", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+16, "Remaining:", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+100, zone.zone.y+0, capRem .. "%", CUSTOM_COLOR + DBLSIZE) --report percent
  lcd.drawText(zone.zone.x+2, zone.zone.y+40, "Capacity Used:" , CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+56, capUsed .. " mAh", CUSTOM_COLOR) --report capacity used
  lcd.drawText(zone.zone.x+2, zone.zone.y+80, "Useable Battery:", CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+2, zone.zone.y+96, capTotal .. " mAh", CUSTOM_COLOR) -- report usable size set in options
  lcd.setColor(CUSTOM_COLOR, getPercentColor(capRem))
  lcd.drawGauge(zone.zone.x+2, zone.zone.y+120, 170, 20, capRem, 100, CUSTOM_COLOR)
  lcd.drawText(zone.zone.x+75, zone.zone.y+120, capRem.."%", TEXT_INVERTED_COLOR + SHADOWED)
end
-- Large, Size: 390x170 (full)
local function zoneXLarge(zone)
  lcd.drawText(zone.zone.x+56, zone.zone.y+56, "Please use Large size widget.", CUSTOM_COLOR + BLINK + INVERS)
end
-- hope to impliment playValue here as well as refresh() to call percents when widget isn't visible
local function background(myZone)
  local capRem  = calc(capUsed, capTotal)
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