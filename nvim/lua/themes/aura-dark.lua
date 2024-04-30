-- this line for types, by hovering and autocompletion (lsp required)
-- will help you understanding properties, fields, and what highlightings the color used for
---@type Base46Table
local M = {}

-- UI
M.base_30 = {
  white = "#edecee",
  black = "#000000", -- main background
  darker_black = "#121016",
  black2 = "#1e1d22",
  one_bg = "#1f1e23", 
  one_bg2 = "#222126",
  one_bg3 = "#252429",
  grey = "#2d2c31",
  grey_fg = "#343339",
  grey_fg2 = "#3b3a3f",
  light_grey = "#424147",
  red = "#ff6767",
  baby_pink = "#ff8080",
  pink = "#ff77a8",
  line = "#2e2d33", 
  green = "#61ffca",
  vibrant_green = "#49c29a",
  nord_blue = "#82e2ff",
  blue = "#a277ff",
  seablue = "#61ffca",
  yellow = "#ffca85",
  sun = "#ffc978",
  purple = "#c678dd",
  dark_purple = "#8e71c7",
  teal = "#4db5bd",
  orange = "#fe8019",
  cyan = "#46D9FF",
  statusline_bg = "#19181e",
  lightbg = "#2a2930",
  pmenu_bg = "#1e1d22",
  folder_bg = "#a277ff"
}

-- Base16 colors map
M.base_16 = {
  base00 = "#15141b",
  base01 = "#1f1e23",
  base02 = "#282726",
  base03 = "#31302f",
  base04 = "#3b3a3f",
  base05 = "#cdccce",
  base06 = "#d8d7d9",
  base07 = "#edecee",
  base08 = "#ff6767",
  base09 = "#ffca85",
  base0A = "#61ffca",
  base0B = "#a277ff",
  base0C = "#61ffca",
  base0D = "#a277ff",
  base0E = "#ffca85",
  base0F = "#ff6767"
}

-- OPTIONAL
-- overriding or adding highlights for this specific theme only 
-- defaults/treesitter is the filename i.e integration there, 

M.polish_hl = {
  defaults = {
    Comment = {
      bg = "#15141b", 
      fg = "#6d6d6d",
      italic = true,
    },
    String = {
      fg = "#61ffca",
    },
    Keyword = {
      fg = "#a277ff",
    },
    Function = {
      fg = "#ffca85",
    },
    Variable = {
      fg = "#edecee",
    }
  },

  treesitter = {
    ["@variable"] = { fg = "#edecee" },
    ["@function"] = { fg = "#ffca85" },
    ["@keyword"] = { fg = "#a277ff" },
    ["@string"] = { fg = "#61ffca" }
  },
}

-- set the theme type whether is dark or light
M.type = "dark" -- "or light"

-- this will be later used for users to override your theme table from chadrc
M = require("base46").override_theme(M, "aura-dark")

return M

