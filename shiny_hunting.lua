local SAVE_SLOT = 1
local a_press_count = 0
local attempts = 0
local egg_detected = false

savestate.load(SAVE_SLOT)

local function press(button, frames)
    for i = 1, frames do
        joypad.set(11, {[button] = true})
        emu.frameadvance()
    end
end

local function mash(button, frames)
    for i = 1, frames do
        joypad.set(1, {[button] = true})
        emu.frameadvance()
        joypad.set(1, {})
        emu.frameadvance()

        emu.frameadvance()

        if button == "A" then
            a_press_count = a_press_count + 1
        end
    end
end

local function press_a()
    joypad.set({["A"] = true})
    emu.frameadvance()
    joypad.set({})
    emu.frameadvance()
end

local function talk_to_aid()
    mash("A",300)
    print("A was pressed " .. a_press_count .. " times.")
end

local function get_player_x()
    return memory.readbyte(0x02096FAC)  -- Player X coordinate in overworld
end

local function is_hatching()
    -- Debug info
    gui.text(5, 40, "Checking for egg hatching...", "white")
    
    -- Define area to scan - adjust these based on your game
    local x_start, y_start = 50, 0
    local x_end, y_end = 200, -150
    
    -- Count white pixels to avoid false positives
    local white_pixel_count = 0
    local total_pixels_checked = 0
    
    -- Loop through the region pixel by pixel (sample fewer pixels for performance)
    for x = x_start, x_end, 5 do
        for y = y_start, y_end, 5 do
            local r, g, b = gui.getpixel(x, y)
            total_pixels_checked = total_pixels_checked + 1
            
            -- Debug: Draw a small dot where we're checking
            gui.box(x, y, "red")
            
            -- White pixel detection (egg turns white before hatching)
            if r > 240 and g > 240 and b > 240 then
                white_pixel_count = white_pixel_count + 1
                gui.box(x, y, "green") -- Mark white pixels in green
            end
        end
    end
    
    -- Display the pixel count info
    gui.text(5, 60, "White pixels: " .. white_pixel_count .. "/" .. total_pixels_checked, "white")
    
    -- If we find enough white pixels, it's likely hatching
    if white_pixel_count > 10 then
        gui.text(5, 80, "EGG HATCHING DETECTED!", "green")
        egg_detected = true
        print("Egg hatching detected!")
        press_a() -- Press A to advance the hatching dialogue
        return true
    end
    
    return false
end


local function scan_for_changes()
    -- Use this function to scan for memory changes when an egg hatches
    -- This helps identify the correct addresses to monitor
    
    -- Define memory range to scan
    local start_addr = 0x02000000
    local end_addr = 0x02200000
    local step = 0x100 -- Scan every 256 bytes for performance
    
    -- Store initial values
    local initial_values = {}
    gui.text(5, 20, "Scanning memory baseline...", "white")
    
    for addr = start_addr, end_addr, step do
        initial_values[addr] = memory.readbyte(addr)
    end
    
    gui.text(5, 20, "Baseline complete. Move around until egg hatches.", "white")
    
    -- Main scanning loop
    local found_changes = 0
    while found_changes < 10 do -- Stop after finding 10 changes
        -- Let the game run
        emu.frameadvance()
        
        -- Check for input to cancel
        local input = joypad.get()
        if input["Start"] then
            break
        end
        
        -- Scan for changes
        for addr = start_addr, end_addr, step do
            local current = memory.readbyte(addr)
            if current ~= initial_values[addr] then
                found_changes = found_changes + 1
                gui.text(5, 40 + (found_changes * 15), 
                         string.format("Change at %08X: %02X -> %02X", 
                         addr, initial_values[addr], current), "yellow")
                
                -- Update the baseline
                initial_values[addr] = current
                
                -- Stop if we found enough changes
                if found_changes >= 10 then
                    break
                end
            end
        end
    end
    
    gui.text(5, 40 + ((found_changes + 1) * 15), "Scan complete.", "green")
end


local function walk_until_wall(direction)
    local last_x = get_player_x()
    while true do
        --check if egg is hatching
        if is_hatching() then 
            press_a() 
            return  
        end
        -- Hold direction (with optional B for running)
        joypad.set({[direction] = true})
        emu.frameadvance()

        local current_x = get_player_x()
        if current_x == last_x then
            -- Stopped moving = hit wall
            break
        end
        last_x = current_x
    end

    -- Release input after hitting wall
    joypad.set({})
    emu.frameadvance()
end

local function walk_pokemart_loop()
    while not egg_detected do
        walk_until_wall("left")
        walk_until_wall("right")
    end
end

    while not egg_detected do
        -- scan_for_changes()
        -- break
        -- savestate.load(SAVE_SLOT)
        talk_to_aid() 
        walk_pokemart_loop()

        -- attempts = attempts + 1
        

    end
    print("Shniy in " ..attempts)
