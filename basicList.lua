--basicList.lua

--Require
local widget = require( "widget" ) --widgets supplied by corona, not in a file
local globals = require("globals")
local constants = require("constants")
local composer = require("composer")

local scene = composer.newScene()

-- local forward references should go here --globals

-- Called when the scene's view does not exist:
function scene:create( event )
    
    local sceneGroup = self.view
    
    
    local listGroup = display.newGroup()
    sceneGroup:insert(listGroup)
    
    local function onRowRender( event )
        
        -- Get reference to the row group
        local row = event.row
        
        -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as 
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth
        
        local rowTitle
        local rowText
        
        if (row.isCategory) then
            if row.index == 1 then
                rowText = "CATEGORY 1"
                rowTitle = display.newText(row, rowText, 0, 0, 310, rowHeight, globals.font.regular, 20)
                rowTitle.x = constants.leftPadding
            else
                rowText = "CATEGORY " .. row.index % 10 + 1
                rowTitle = display.newText(row, rowText, 0, 0, 310, rowHeight, globals.font.regular, 20) 
                rowTitle.x = constants.leftPadding
            end
        else
            rowTitle = display.newText(row, globals.data.lists[1][row.index], 0,0, 310, rowHeight, globals.font.regular, 20, left)
            rowTitle:setFillColor(0,0,0)
            rowTitle.x = constants.leftPadding
        end
        
        -- Align the label left and vertically centered
        rowTitle.anchorX = 0
        rowTitle.x = 0
        rowTitle.y = rowHeight * 0.5
    end
    local function onRowTouch(event)
        local row = event.target
        print( "Tapped to rename row: " .. row.index )
        globals.basicListTableView:deleteRow( row.index )
        table.remove(globals.data.lists[1][row.index], row.index)
        --        globals.data.lists[1][row.index] = "   Random Name"
        --        globals.basicListTableView:reloadData()
        --        print("renamed row " .. globals.data.lists[1][row.index])
        saveTable(globals.data, "data.json")
    end
    -- Create the widget
    globals.basicListTableView = widget.newTableView
    {
        left = 0,
        top = 120, --50
        height = 440,
        width = 320,
        hideScrollBar = true,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch
    }
    listGroup:insert(globals.basicListTableView)
    
    -- Insert globals.basicListT.numRows rows
    for i = 1, #globals.data.lists[1] do
        
        -- default is that row isn't a category
        --these are the white rows
        isCategory = false
        rowHeight = 36
        rowColor = { default={1,1,1} }
        
        --        -- Make some rows categories
        --        --these are the dark blues
        --        if ( i == 1 or i % 11 == 0 ) then
        --            isCategory = true
        --            rowHeight = 50
        --            rowColor = { default={constants.darkblue.r, constants.darkblue.g, constants.darkblue.b} }
        --        end
        
        -- Insert a row into the tableView
        globals.basicListTableView:insertRow(
        {
            isCategory = isCategory,
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = {0.93333333333, 0.93333333333, 0.93333333333}
        }
        )
        
    end
    --Create navigation things
    local navBar = display.newRect(320, 20, 640, 100)
    
    navBar:setFillColor(constants.darkteal.r, constants.darkteal.g, constants.darkteal.b)
    listGroup:insert(navBar)
    
    local toListsIcon = display.newImage("images/navArrowIcon.png")
    toListsIcon.x, toListsIcon.y =constants.defaultIconPlace.x, constants.defaultIconPlace.y
    listGroup:insert(toListsIcon)
    local function goToLists()
        
        globals.middleText.text = globals.listName
        globals.placeholderText = "Tap to add an item into " .. "To Do"
        composer.gotoScene("lists", {effect = "slideRight"})
        -- = display.newText(listGroup, globals.listName, constants.centerX, 43, globals.font.regular, 20) -- middleText is the name of the list
        
        --middleText:setFillColor(0,0,0) 
    end
    toListsIcon:addEventListener("tap", goToLists)
    
    globals.middleText = display.newText(listGroup, "To Do", constants.centerX, 43, globals.font.regular, 20) -- middleText is the name of the list
    
    globals.middleText:setFillColor(0,0,0) 
    
    --    local navAddIcon = display.newImage("images/navAddIcon.png")
    --    navAddIcon.x, navAddIcon.y = constants.centerX + 125, 23
    --    listGroup:insert(navAddIcon)
    
    local function getListName(event)
        if (event.phase == "submitted") then
            local rowName = globals.textWrap(event.target.text, 36, "   ", nil)
            if string.len(event.target.text) > 28 then rowHeight = 64 else rowHeight = 36 end
            globals.data.lists[1][#globals.data.lists[1]+1] = rowName
            native.setKeyboardFocus( event.target )
            print ("User added row #" .. #globals.data.lists[1] .. globals.data.lists[1][#globals.data.lists[1]])
            -- Insert a row into the tableView
            globals.basicListTableView:insertRow(
            {
                isCategory = false,
                rowHeight = rowHeight,
                rowColor = { default={1,1,1} },
                lineColor = {0.93333333333, 0.93333333333, 0.93333333333}
            }
            )
            if #globals.data.lists[1] > 5 then
                globals.basicListTableView:scrollToIndex(#globals.data.lists[1] - 4, 700)
            end
            event.target.text = '' --clear textfield
            saveTable(globals.data, "data.json")
        end
    end
    --Create text field
    globals.taskNameField = native.newTextField( 158, 97, 322, 55) --centerX, centerY, width, height
    globals.taskNameField.placeholder = globals.placeholderText
    --if touched, go to getListName
    globals.taskNameField:addEventListener("userInput",getListName)
end

function scene:show( event )
    
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
    end
end

-- "scene:hide()"
function scene:hide( event )
    
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        native.setKeyboardFocus( nil )
        globals.taskNameField:toBack()
        
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end

-- "scene:destroy()"
function scene:destroy( event )
    
    local sceneGroup = self.view
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene