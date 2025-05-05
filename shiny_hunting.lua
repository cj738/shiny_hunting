local SAVE_SLOT = 1
local a_press_count = 0
local attempts = 0
local egg_detected = false

-- savestate.load(SAVE_SLOT)

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

local function soft_reset()
for i = 1, 5 do
    joypad.set({["L"]=true, ["R"]=true, ["start"]=true, ["select"]=true})
    emu.frameadvance()
end
    joypad.set({})
    emu.frameadvance()
end

local function mash_a()
    mash("A",5)
end

local function talk_to_aid()
    mash("A",600)
end

local function get_player_x()
    return memory.readbyte(0x02096FAC)  -- Player X coordinate in overworld
end


local function walk_steps(direction, steps)
    local FRAMES_PER_STEP = 15  -- adjust if needed

    for i = 1, steps do
        for f = 1, FRAMES_PER_STEP do
            joypad.set({[direction] = true})
            emu.frameadvance()
        end
        -- Release input briefly between steps
        joypad.set({})
        emu.frameadvance()
    end
end

local function walk_pokemart_loop()
    local total_steps = 0
    while total_steps < 775 do
        walk_steps("right", 5)
        total_steps = total_steps + 5

        walk_steps("left", 5)
        total_steps = total_steps + 5
    end
end



soft_reset()
talk_to_aid()
walk_pokemart_loop()
mash_a()
    
