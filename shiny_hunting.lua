-- Memory addresses for HeartGold/SoulSilver (DeSmuME)
local TID_ADDR = 0x0223BBC4 -- 2 bytes
local SID_ADDR = 0x0223BBC6 -- 2 bytes
local PARTY_BASE = 0x02101D2C -- Base address of first Pokémon in party
local PID_OFFSET = 0x00 -- PID is first 4 bytes of Pokémon data

-- Functions to read memory
local function read16(addr)
    return memory.read_u16_le(addr)
end

local function read32(addr)
    return memory.read_u32_le(addr)
end

-- Display values on screen each frame
local function print_memory()
    local tid = read16(TID_ADDR)
    local sid = read16(SID_ADDR)
    local pid = read32(PARTY_BASE + PID_OFFSET)

    gui.drawText(10, 10, string.format("TID: %d", tid), "white")
    gui.drawText(10, 30, string.format("SID: %d", sid), "white")
    gui.drawText(10, 50, string.format("PID: 0x%08X", pid), "yellow")

    emu.frameadvance()
end

while true do
    print_memory()
end
