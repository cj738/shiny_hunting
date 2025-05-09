import subprocess
import time
from dotenv import load_dotenv
import os
import pyautogui
import pygetwindow as gw

load_dotenv()

desume_path = os.getenv("EMU_DIR") + "\\DeSmuME_0.9.13_x64.exe"
rom_path = os.getenv("ROM_DIR") + "\\4780 - Pokemon HeartGold (U)(Xenophobia).nds"
num_instances = 8
target_title = "DeSmuME 0.9.13 x64 SSE2 | Pokémon HeartGold"

# Step 1: Launch all instances
for i in range(num_instances):
    subprocess.Popen([desume_path, rom_path])
    time.sleep(1)  # small delay between launches

