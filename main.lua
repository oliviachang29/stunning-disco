--Checklist: main.lua
--(c) 2014 Olivia Chang
--require "CiderDebugger";


display.setStatusBar(display.HiddenStatusBar)
--system.activate( "multitouch" )
local json = require("json")
local storyboard = require("storyboard") --so it can go to scenes

local background = display.newRect( display.screenOriginX,
display.screenOriginY, 
display.pixelWidth, 
display.pixelHeight)

background.x, background.y = display.contentCenterX,  display.contentCenterY
background:setFillColor(238/255, 238/255, 238/255)

background:toBack()

globals = require ("globals")

globals.blRows = {}

globals.blRows = loadTable("blrows.json")
if globals.blRows == nil then
	globals.blRows = {}
end

storyboard.gotoScene("basicList")