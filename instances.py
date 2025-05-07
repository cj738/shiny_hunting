import subprocess
import time
from dotenv import load_dotenv
import os
import pyautogui
import pygetwindow as gw

load_dotenv()

desume_path = os.getenv("EMU_DIR") + "\\DeSmuME_0.9.13_x64.exe"
rom_path = os.getenv("ROM_DIR") + "\\4780 - Pokemon HeartGold (U)(Xenophobia).nds"
lua_path = os.getenv("LUA_PATH")

num_instances = 1

print(desume_path)

for i in range(num_instances):
    subprocess.Popen([
        desume_path
        , rom_path
        ])
 