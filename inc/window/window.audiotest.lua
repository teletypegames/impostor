AudioTestWindow = {
    index_menu = 1,
    index_func = 1,
    list_func = {},
    menuitems = {},
    last_pressed = false
}

--- Generates menu items for audio test.
-- @param list_func table List of audio functions.
-- @param index_func number Current index of selected function.
-- @return table Generated menu items.
function AudioTestWindow.generate_menuitems(list_func, index_func)
    return {
        {
            label = "Play music/sound: " .. (list_func[index_func] or "?"),
            decision = function()
                local current_func = Audio[list_func[index_func]]
                if current_func then
                    current_func()
                else
                    trace("Invalid Audio function: " .. list_func[index_func])
                end
            end
        },
        {
            label = "Stop playing music",
            decision = function()
                Audio.music_stop()
            end
        },
        {
            label = "Back",
            decision = function()
                AudioTestWindow.back()
            end
        },
    }
end

--- Generates list of audio functions.
-- @return table A sorted list of audio function names.
function AudioTestWindow.generate_listfunc()
    local result = {}

    for k, v in pairs(Audio) do
        if type(v) == "function" then
            result[#result + 1] = k
        end
    end

    table.sort(result)

    return result
end

--- Navigates back from audio test window.
function AudioTestWindow.back()
    Audio.sfx_deselect()
    GameWindow.set_state("menu")
end

--- Initializes audio test window.
function AudioTestWindow.init()
    AudioTestWindow.last_pressed = false
    AudioTestWindow.index_menu = 1
    AudioTestWindow.index_func = 1
    AudioTestWindow.list_func = AudioTestWindow.generate_listfunc()
    AudioTestWindow.menuitems = AudioTestWindow.generate_menuitems(
        AudioTestWindow.list_func, AudioTestWindow.index_func
    )
end

--- Draws audio test window.
function AudioTestWindow.draw()
    UI.draw_top_bar("Audio test")
    UI.draw_menu(AudioTestWindow.menuitems, AudioTestWindow.index_menu, 20, 50)
end

--- Updates audio test window logic.
function AudioTestWindow.update()
    if Input.up() then
        AudioTestWindow.index_menu = Util.safeindex(AudioTestWindow.menuitems, AudioTestWindow.index_menu - 1)
    elseif Input.down() then
        AudioTestWindow.index_menu = Util.safeindex(AudioTestWindow.menuitems, AudioTestWindow.index_menu + 1)
    elseif Input.left() then
        AudioTestWindow.index_func = Util.safeindex(
            AudioTestWindow.list_func,
            AudioTestWindow.index_func - 1
        )
        AudioTestWindow.menuitems = AudioTestWindow.generate_menuitems(
            AudioTestWindow.list_func, AudioTestWindow.index_func
        )
    elseif Input.right() then
        AudioTestWindow.index_func = Util.safeindex(
            AudioTestWindow.list_func,
            AudioTestWindow.index_func + 1
        )
        AudioTestWindow.menuitems = AudioTestWindow.generate_menuitems(
            AudioTestWindow.list_func, AudioTestWindow.index_func
        )
    elseif Input.menu_confirm() then
        AudioTestWindow.menuitems[AudioTestWindow.index_menu].decision()
    elseif Input.menu_back() then
        AudioTestWindow.back()
    end
end
