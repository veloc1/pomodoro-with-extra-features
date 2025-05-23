local M = {}

function M.init_main_screen()
    local result = M.init_display()

    M.change_module(clock_module)
    if (result) then
        M.start_thread()
    end
end

function M.init_display()
    if pcall(function() gdisplay.attach(gdisplay.SSD1306_128_64, gdisplay.LANDSCAPE, false) end) then
         -- gdisplay.setfont(gdisplay.FONT_UBUNTU16)
        -- gdisplay.setfont(gdisplay.FONT_MINYA24)
        -- gdisplay.setfont(gdisplay.FONT_DEFAULT)
        gdisplay.setfont(gdisplay.FONT_7SEG)
        gdisplay.setforeground(gdisplay.WHITE)
        gdisplay.setbackground(gdisplay.BLACK)
        gdisplay.settransp(false)
        return true
    else
        print("cannot init main display")
        return false
    end
end


function M.start_thread()
    M.thread = thread.start(function()
        print("started main screen")
        -- M.main_screen_module = MainMenu()

        while true do
            M.update()

            M.main_screen_module.update()
            if M.main_screen_module.need_redraw then
                M.main_screen_module.draw()
            end

            -- tmr.delayms(16)
            tmr.delayms(64)
        end
    end)
end

function M.change_module(new_module)
    if (M.main_screen_module) then
    end

    gdisplay.clear()

    M.main_screen_module = new_module
    M.main_screen_module.on_show()
    M.main_screen_module.update()
    M.main_screen_module.draw()
end

function M.update()
  -- do nothing there
end

return M
