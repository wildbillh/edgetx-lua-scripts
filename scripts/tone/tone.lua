
-- tone.lua
-- Script to emulate motor sound using the EdgeTX playTone function.
-- While somewhat annoying in use, this is a good introduction to using LUA.
-- This script has been tested on a RadioMaster TX16s Max 3 in flight and with EdgeTX companion.
-- USE AT YOUR OWN RISK!
-- Author Bill Hodges

-- Constants

-- The values for duration, min frequency, max frequency and min throttle can be stored
-- as global variables. This feature is turned off by setting USE_GLOBAL_VARIABLES to false.
-- If set to true and the particular global variable is unset (=0), the default will be used.

local USE_GLOBAL_VARIABLES = true


-- My radio has 15 global variables available. If yours has fewer, these values need to be changed. 
-- Global variable indexes
local GVI_DURATION = 11
local GVI_MIN_FREQ = 12
local GVI_MAX_FREQ = 13
local GVI_MIN_THROTTLE = 14


-- Defaults. Note these can be overwritten if Global Variables are utilized.

-- Play length in ms for each call
local PLAY_DURRATION_MS = 100
-- Lowest frequency to output
local MIN_FREQ = 300
-- Highest frequency to output
local MAX_FREQ = 800
-- Throttle position to start output
local MIN_THROTTLE = -950
-- The number of discrete frequency steps
local FREQ_STEPS = MAX_FREQ - MIN_FREQ
-- The number of discrete throttle steps
local THROTTLE_STEPS = 1024 - MIN_THROTTLE
-- The number of frequency steps to change for one throttle step change
local FREQ_PER_THROTTLE_STEPS = FREQ_STEPS / THROTTLE_STEPS

-- A placeholder for the throttle id 
local throttleId = nil


-- --------------------------- Required init function ------------------------
local function init ()
   
    -- Get the throttle index. If this fails we return and the run script will do nothing later
    
    local fi = getFieldInfo("thr")
    if fi and fi.id then
        -- We found it so set the index
        throttleId = fi.id
    else
        return
    end

    -- If global variables are not utilized, nothing more to do
    if not USE_GLOBAL_VARIABLES then
        return
    end

    -- If one or more of the global variables are found (!=0),, we have to recalculate the interim values
    local recalculate = false

    -- Check each global variable to see if we need to overwrite a default

    local temp = model.getGlobalVariable(GVI_DURATION,0)
    if temp and temp ~= 0 then
        -- Set the new values based on the new duration setting
        PLAY_DURRATION_MS = temp
        recalculate = true
    end

    temp = model.getGlobalVariable(GVI_MIN_FREQ,0)
    if temp and temp ~= 0 then
        -- Set the new values based on the new min frequency setting
        MIN_FREQ = temp
        recalculate = true
    end

    temp = model.getGlobalVariable(GVI_MAX_FREQ,0)
    if temp and temp ~= 0 then
        -- Set the new values based on the new max frequency setting
        MAX_FREQ = temp
        recalculate = true
    end

    -- Check for a global variable to override MIN_THROTTLE
    temp = model.getGlobalVariable(GVI_MIN_THROTTLE,0)
    if temp and temp ~= 0 then
        -- Set the new values based on the new min throttle setting
        MIN_THROTTLE = temp
        recalculate = true
    end

    -- Recalculate all of the values if any have changed
    if recalculate then
        FREQ_STEPS = MAX_FREQ - MIN_FREQ
        THROTTLE_STEPS = 1024 - MIN_THROTTLE
        FREQ_PER_THROTTLE_STEPS = FREQ_STEPS / THROTTLE_STEPS
    end
    
end

-- --------------------------- Required run function ---------------------------------
local function run()

    -- Safety check to make sure we have a throttle id
    if not throttleId then
        return
    end

    -- Get the current value of the throttle. Ranges from -1024 to 1024
    local throttleVal = getValue(throttleId)
    
    -- Only generate a tone if the throttle position is above the set minimum
    if throttleVal and throttleVal > MIN_THROTTLE then
        -- Calculate the tone frequency based on the throttle value
        local frequency = MIN_FREQ + math.floor(FREQ_PER_THROTTLE_STEPS * (throttleVal - MIN_THROTTLE))
        -- Play the tone
        playTone(frequency, PLAY_DURRATION_MS, 0)
    end
end


-- -------------------------- Required background function ---------------------------
local function background()
end


-- ----------------------------------------------------------------------------
return { run = run, background=background, init=init}
