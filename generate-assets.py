#!/usr/bin/env python3
"""Generate all SNES-style pixel art assets for Gospel RPG."""

import json
import os
from PIL import Image, ImageDraw

BASE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "GospelRPG", "Assets.xcassets")

def save_asset(name, img):
    """Save image as Xcode asset catalog entry."""
    folder = os.path.join(BASE, f"{name}.imageset")
    os.makedirs(folder, exist_ok=True)
    img.save(os.path.join(folder, f"{name}.png"))
    contents = {
        "images": [{"filename": f"{name}.png", "idiom": "universal", "scale": "1x"},
                    {"idiom": "universal", "scale": "2x"},
                    {"idiom": "universal", "scale": "3x"}],
        "info": {"author": "xcode", "version": 1}
    }
    with open(os.path.join(folder, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)

# ─── COLOR PALETTES ───
SKIN = "#E8B878"
SKIN_DARK = "#C89858"
HAIR_BROWN = "#5A3A1A"
HAIR_BLACK = "#2A1A0A"
WHITE_ROBE = "#F0F0E8"
WHITE_SHADOW = "#C8C8B8"
BLUE_ROBE = "#4878A8"
BLUE_SHADOW = "#385878"
RED_ROBE = "#B83838"
BROWN = "#8B6838"
BROWN_DARK = "#5A4828"
GOLD = "#D8A830"
GOLD_LIGHT = "#F0D060"
HALO_COLOR = "#F8E878"
METAL_GRAY = "#A0A0A8"
METAL_DARK = "#686878"
SANDAL = "#A07838"
EYE = "#182838"
PURPLE = "#7838A0"
PURPLE_DARK = "#582878"
GREEN_DARK = "#385828"
DEMON_RED = "#A01818"
DEMON_DARK = "#681010"

# ─── HELPER ───
def px(draw, x, y, color):
    draw.point((x, y), fill=color)

def rect(draw, x1, y1, x2, y2, color):
    draw.rectangle([x1, y1, x2, y2], fill=color)

def outline_rect(draw, x1, y1, x2, y2, fill, outline):
    draw.rectangle([x1, y1, x2, y2], fill=fill, outline=outline)

# ─── CHARACTER SPRITE FACTORY ───
def make_sprite(robe_color, robe_shadow, hair_color, extras=None):
    """Create a 32x32 front-facing character sprite."""
    img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    # Hair/head (rows 4-11, cols 11-20)
    rect(d, 12, 4, 19, 6, hair_color)   # hair top
    rect(d, 11, 7, 20, 7, hair_color)   # hair sides
    # Face
    rect(d, 12, 7, 19, 12, SKIN)
    rect(d, 11, 8, 11, 11, hair_color)  # left hair side
    rect(d, 20, 8, 20, 11, hair_color)  # right hair side
    # Eyes
    px(d, 14, 9, EYE)
    px(d, 17, 9, EYE)
    # Mouth
    px(d, 15, 11, SKIN_DARK)
    px(d, 16, 11, SKIN_DARK)

    # Neck
    rect(d, 14, 13, 17, 13, SKIN)

    # Torso (robe)
    rect(d, 10, 14, 21, 22, robe_color)
    rect(d, 10, 14, 12, 22, robe_shadow)  # left shadow
    rect(d, 19, 14, 21, 22, robe_shadow)  # right shadow

    # Arms
    rect(d, 8, 15, 9, 21, robe_color)
    rect(d, 22, 15, 23, 21, robe_color)
    # Hands
    rect(d, 8, 22, 9, 23, SKIN)
    rect(d, 22, 22, 23, 23, SKIN)

    # Belt/sash
    rect(d, 10, 20, 21, 20, robe_shadow)

    # Legs/robe bottom
    rect(d, 12, 23, 15, 27, robe_color)
    rect(d, 16, 23, 19, 27, robe_shadow)

    # Sandals
    rect(d, 11, 28, 15, 29, SANDAL)
    rect(d, 16, 28, 20, 29, SANDAL)

    if extras:
        extras(d, img)

    return img

def jesus_extras(d, img):
    # Halo
    rect(d, 13, 2, 18, 3, HALO_COLOR)
    rect(d, 12, 3, 12, 3, HALO_COLOR)
    rect(d, 19, 3, 19, 3, HALO_COLOR)
    # Sash gold
    rect(d, 14, 20, 17, 20, GOLD)

def fisherman_extras(d, img):
    # Headband
    rect(d, 12, 6, 19, 6, BROWN)

def soldier_extras(d, img):
    # Helmet
    rect(d, 11, 3, 20, 6, METAL_GRAY)
    rect(d, 14, 2, 17, 2, METAL_DARK)  # crest
    rect(d, 15, 1, 16, 1, "#C83030")   # red plume
    # Shield in left hand
    rect(d, 5, 16, 9, 22, METAL_GRAY)
    rect(d, 6, 17, 8, 21, METAL_DARK)
    # Spear in right hand
    rect(d, 23, 8, 23, 23, BROWN)
    rect(d, 22, 7, 24, 9, METAL_GRAY)

def pharisee_extras(d, img):
    # Phylactery on forehead
    rect(d, 14, 5, 17, 6, "#1A1A1A")
    # Long beard
    rect(d, 13, 12, 18, 15, HAIR_BLACK)

def demon_extras(d, img):
    # Horns
    px(d, 12, 3, DEMON_RED)
    px(d, 11, 2, DEMON_RED)
    px(d, 19, 3, DEMON_RED)
    px(d, 20, 2, DEMON_RED)
    # Red eyes
    px(d, 14, 9, "#FF0000")
    px(d, 17, 9, "#FF0000")
    # Claws
    rect(d, 7, 22, 9, 24, DEMON_RED)
    rect(d, 22, 22, 24, 24, DEMON_RED)

def villager_f_extras(d, img):
    # Headscarf
    rect(d, 11, 4, 20, 7, "#C87858")
    # Re-draw face on top
    rect(d, 12, 7, 19, 12, SKIN)
    px(d, 14, 9, EYE)
    px(d, 17, 9, EYE)
    px(d, 15, 11, SKIN_DARK)
    px(d, 16, 11, SKIN_DARK)

# ─── GENERATE CHARACTERS ───
print("Generating character sprites...")
chars = {
    "jesus":        (WHITE_ROBE, WHITE_SHADOW, HAIR_BROWN, jesus_extras),
    "peter":        (BLUE_ROBE, BLUE_SHADOW, HAIR_BROWN, fisherman_extras),
    "andrew":       (BLUE_ROBE, BLUE_SHADOW, HAIR_BLACK, fisherman_extras),
    "james":        ("#78A848", "#587838", HAIR_BROWN, None),
    "john":         ("#78A848", "#587838", HAIR_BLACK, None),
    "disciple":     (BROWN, BROWN_DARK, HAIR_BROWN, None),
    "enemy_soldier":(METAL_GRAY, METAL_DARK, HAIR_BLACK, soldier_extras),
    "enemy_pharisee":(PURPLE, PURPLE_DARK, HAIR_BLACK, pharisee_extras),
    "enemy_demon":  (DEMON_RED, DEMON_DARK, HAIR_BLACK, demon_extras),
    "npc_villager_m":(BROWN, BROWN_DARK, HAIR_BROWN, None),
    "npc_villager_f":("#C8A878", "#A88858", HAIR_BLACK, villager_f_extras),
}
for name, (rc, rs, hc, ex) in chars.items():
    if name == "enemy_demon":
        img = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
        d = ImageDraw.Draw(img)
        # Demon body - more monstrous
        rect(d, 10, 8, 21, 22, DEMON_RED)
        rect(d, 12, 5, 19, 12, DEMON_DARK)
        # Eyes
        px(d, 14, 8, "#FFFF00")
        px(d, 17, 8, "#FFFF00")
        px(d, 15, 8, "#FFFF00")
        px(d, 16, 8, "#FFFF00")
        # Mouth
        rect(d, 13, 10, 18, 11, "#200000")
        # Horns
        px(d, 12, 4, DEMON_RED); px(d, 11, 3, DEMON_RED)
        px(d, 19, 4, DEMON_RED); px(d, 20, 3, DEMON_RED)
        # Wings
        rect(d, 5, 10, 9, 18, DEMON_DARK)
        rect(d, 22, 10, 26, 18, DEMON_DARK)
        # Claws
        rect(d, 8, 22, 10, 24, DEMON_RED)
        rect(d, 21, 22, 23, 24, DEMON_RED)
        # Legs
        rect(d, 12, 23, 14, 28, DEMON_DARK)
        rect(d, 17, 23, 19, 28, DEMON_DARK)
        # Tail
        px(d, 22, 22, DEMON_RED); px(d, 23, 23, DEMON_RED); px(d, 24, 24, DEMON_RED)
        save_asset(name, img)
    else:
        save_asset(name, make_sprite(rc, rs, hc, ex))

# ─── TILES (16x16) ───
print("Generating tiles...")

def make_tile(base_color, detail_func=None):
    img = Image.new("RGBA", (16, 16), base_color)
    d = ImageDraw.Draw(img)
    if detail_func:
        detail_func(d)
    return img

import random
random.seed(42)

def grass_detail(d):
    for _ in range(12):
        x, y = random.randint(0,15), random.randint(0,15)
        d.point((x,y), fill="#48A030" if random.random()>0.5 else "#388020")

def sand_detail(d):
    for _ in range(8):
        x, y = random.randint(0,15), random.randint(0,15)
        d.point((x,y), fill="#E8D898" if random.random()>0.5 else "#C8B878")

def water_detail(d):
    for y in range(0, 16, 4):
        for x in range(0, 16, 2):
            if random.random() > 0.6:
                d.point((x, y), fill="#78C8F0")

def stone_floor_detail(d):
    d.line([(0,7),(15,7)], fill="#989088")
    d.line([(7,0),(7,15)], fill="#989088")

def dirt_detail(d):
    for _ in range(6):
        x, y = random.randint(0,15), random.randint(0,15)
        d.point((x,y), fill="#987858")

def stone_wall_detail(d):
    d.line([(0,5),(15,5)], fill="#484848")
    d.line([(0,10),(15,10)], fill="#484848")
    d.line([(4,0),(4,5)], fill="#484848")
    d.line([(11,5),(11,10)], fill="#484848")
    d.line([(7,10),(7,15)], fill="#484848")

def mud_wall_detail(d):
    for _ in range(8):
        x, y = random.randint(0,15), random.randint(0,15)
        d.point((x,y), fill="#A88050")

tiles = {
    "tile_grass":      ("#58A838", grass_detail),
    "tile_sand":       ("#D8C888", sand_detail),
    "tile_water":      ("#3888C8", water_detail),
    "tile_stone_floor":("#A8A098", stone_floor_detail),
    "tile_dirt_path":  ("#A88868", dirt_detail),
    "tile_wall_stone": ("#686868", stone_wall_detail),
    "tile_wall_mud":   ("#B89868", mud_wall_detail),
}
for name, (color, func) in tiles.items():
    save_asset(name, make_tile(color, func))

# Door
img = make_tile("#5A3A1A")
d = ImageDraw.Draw(img)
rect(d, 2, 0, 13, 15, "#7A5A3A")
rect(d, 3, 1, 12, 14, "#5A3A1A")
rect(d, 6, 1, 9, 6, "#7A5A3A")   # panels
rect(d, 6, 8, 9, 13, "#7A5A3A")
px(d, 11, 8, GOLD)  # handle
save_asset("tile_door", img)

# Chest
img = Image.new("RGBA", (16, 16), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 2, 6, 13, 14, BROWN)
rect(d, 2, 6, 13, 9, BROWN_DARK)
rect(d, 6, 8, 9, 10, GOLD)  # lock
rect(d, 1, 14, 14, 15, BROWN_DARK)  # base
save_asset("tile_chest", img)

# Altar
img = Image.new("RGBA", (16, 16), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 3, 4, 12, 14, "#D8D0C8")
rect(d, 2, 4, 13, 5, "#E8E0D8")  # top slab
rect(d, 5, 2, 10, 3, GOLD)  # menorah/candle
px(d, 7, 1, "#F8E040")  # flame
save_asset("tile_altar", img)

# Tree
img = Image.new("RGBA", (16, 16), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 6, 10, 9, 15, BROWN)  # trunk
rect(d, 3, 2, 12, 10, "#388028")  # canopy
rect(d, 5, 1, 10, 3, "#48A038")  # canopy top highlight
save_asset("tile_tree", img)

# Bush
img = Image.new("RGBA", (16, 16), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 2, 6, 13, 14, "#388028")
rect(d, 4, 4, 11, 7, "#48A038")
save_asset("tile_bush", img)

# Rock
img = Image.new("RGBA", (16, 16), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 3, 8, 12, 14, "#787878")
rect(d, 4, 6, 11, 9, "#989898")
rect(d, 5, 7, 8, 8, "#A8A8A8")  # highlight
save_asset("tile_rock", img)

# ─── BATTLE BACKGROUNDS (320x240) ───
print("Generating battle backgrounds...")

def bg_lakeshore():
    img = Image.new("RGB", (320, 240), "#88C8F8")  # sky
    d = ImageDraw.Draw(img)
    # Water
    rect(d, 0, 100, 319, 160, "#3888C8")
    rect(d, 0, 140, 319, 160, "#2878B8")
    # Shore
    rect(d, 0, 161, 319, 200, "#D8C888")
    rect(d, 0, 201, 319, 239, "#C8B878")
    # Sun
    d.ellipse([260, 15, 290, 45], fill="#F8E040")
    # Waves
    for x in range(0, 320, 20):
        d.arc([x, 125, x+18, 140], 0, 180, fill="#78C8F0")
    return img

def bg_desert():
    img = Image.new("RGB", (320, 240), "#E8D898")
    d = ImageDraw.Draw(img)
    # Sky
    rect(d, 0, 0, 319, 80, "#C8A050")
    rect(d, 0, 0, 319, 50, "#F0C868")
    # Sun
    d.ellipse([140, 10, 180, 50], fill="#F8F0A0")
    # Dunes
    d.ellipse([(-40), 100, 160, 200], fill="#D8C080")
    d.ellipse([120, 110, 360, 210], fill="#C8B070")
    # Ground
    rect(d, 0, 180, 319, 239, "#B8A060")
    # Rocks
    rect(d, 50, 170, 70, 180, "#908060")
    rect(d, 240, 175, 260, 182, "#908060")
    return img

def bg_temple():
    img = Image.new("RGB", (320, 240), "#383028")
    d = ImageDraw.Draw(img)
    # Back wall
    rect(d, 0, 0, 319, 120, "#484038")
    # Pillars
    for x in [40, 120, 200, 280]:
        rect(d, x-8, 20, x+8, 180, "#686058")
        rect(d, x-10, 16, x+10, 24, "#787068")
        rect(d, x-10, 176, x+10, 184, "#787068")
    # Floor
    for y in range(180, 240, 16):
        for x in range(0, 320, 32):
            c = "#585048" if (x//32 + y//16) % 2 == 0 else "#484038"
            rect(d, x, y, x+31, y+15, c)
    # Altar at center back
    rect(d, 140, 80, 180, 120, "#A89878")
    rect(d, 135, 76, 185, 82, "#B8A888")
    # Menorah
    px(d, 160, 72, "#F8E040")
    px(d, 155, 74, "#F8E040")
    px(d, 165, 74, "#F8E040")
    return img

def bg_village():
    img = Image.new("RGB", (320, 240), "#88C8F8")
    d = ImageDraw.Draw(img)
    # Ground/street
    rect(d, 0, 140, 319, 239, "#B89868")
    rect(d, 100, 150, 220, 239, "#A88858")  # path
    # Buildings
    for bx, bw, color in [(10,80,"#D8C8A8"), (230,80,"#C8B898")]:
        rect(d, bx, 60, bx+bw, 140, color)
        rect(d, bx+bw//2-8, 110, bx+bw//2+8, 140, "#5A3A1A")  # door
        rect(d, bx+10, 80, bx+25, 95, "#78C8F0")  # window
        rect(d, bx+bw-25, 80, bx+bw-10, 95, "#78C8F0")
        # Roof
        d.polygon([(bx-5, 60), (bx+bw+5, 60), (bx+bw//2, 35)], fill="#A07838")
    return img

def bg_mountain():
    img = Image.new("RGB", (320, 240), "#6898C8")
    d = ImageDraw.Draw(img)
    # Mountains bg
    d.polygon([(0,120),(80,40),(160,120)], fill="#787868")
    d.polygon([(100,120),(200,20),(300,120)], fill="#686858")
    d.polygon([(200,120),(280,50),(340,120)], fill="#787868")
    # Snow caps
    d.polygon([(70,50),(80,40),(90,50)], fill="#F0F0F0")
    d.polygon([(190,30),(200,20),(210,30)], fill="#F0F0F0")
    # Ground
    rect(d, 0, 120, 319, 180, "#58A838")
    rect(d, 0, 180, 319, 239, "#488828")
    # Rocks
    d.ellipse([40, 170, 70, 195], fill="#787878")
    d.ellipse([250, 175, 275, 192], fill="#888888")
    return img

bgs = {
    "bg_lakeshore": bg_lakeshore,
    "bg_desert": bg_desert,
    "bg_temple": bg_temple,
    "bg_village": bg_village,
    "bg_mountain": bg_mountain,
}
for name, func in bgs.items():
    save_asset(name, func())

# ─── UI ELEMENTS ───
print("Generating UI elements...")

# Text box (320x80)
img = Image.new("RGBA", (320, 80), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 0, 0, 319, 79, "#181828")
# Gold border (double line)
outline_rect(d, 0, 0, 319, 79, None, GOLD)
outline_rect(d, 2, 2, 317, 77, None, GOLD)
# Corner accents
for cx, cy in [(0,0),(316,0),(0,76),(316,76)]:
    rect(d, cx, cy, cx+3, cy+3, GOLD_LIGHT)
save_asset("ui_textbox", img)

# Health bar green (64x8)
img = Image.new("RGBA", (64, 8), (0,0,0,0))
d = ImageDraw.Draw(img)
outline_rect(d, 0, 0, 63, 7, "#181818", "#A0A0A0")
rect(d, 2, 2, 61, 5, "#30A030")
rect(d, 2, 2, 61, 3, "#48C848")  # highlight
save_asset("ui_healthbar_green", img)

# Health bar red (64x8)
img = Image.new("RGBA", (64, 8), (0,0,0,0))
d = ImageDraw.Draw(img)
outline_rect(d, 0, 0, 63, 7, "#181818", "#A0A0A0")
rect(d, 2, 2, 61, 5, "#C83030")
rect(d, 2, 2, 61, 3, "#E84848")
save_asset("ui_healthbar_red", img)

# Menu panel (200x160)
img = Image.new("RGBA", (200, 160), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 0, 0, 199, 159, "#181828")
outline_rect(d, 0, 0, 199, 159, None, GOLD)
outline_rect(d, 2, 2, 197, 157, None, GOLD)
for cx, cy in [(0,0),(196,0),(0,156),(196,156)]:
    rect(d, cx, cy, cx+3, cy+3, GOLD_LIGHT)
save_asset("ui_menu_panel", img)

# Battle command box (160x80)
img = Image.new("RGBA", (160, 80), (0,0,0,0))
d = ImageDraw.Draw(img)
rect(d, 0, 0, 159, 79, "#181828")
outline_rect(d, 0, 0, 159, 79, None, GOLD)
outline_rect(d, 2, 2, 157, 77, None, GOLD)
# Cursor indicator
d.polygon([(8, 12), (14, 16), (8, 20)], fill="#F0F0F0")
save_asset("ui_battle_commands", img)

print("✅ All assets generated successfully!")
