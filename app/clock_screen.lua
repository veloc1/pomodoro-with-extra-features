local M = {
    need_redraw = true,
    date = "",
    time = "",
    led_h = 0,
}

function M.on_show()
end

function M.update()
    local timestamp = os.time() + 60 * 60 * 3 -- add timezone
    local date = os.date("%d.%m", timestamp)
    local time = os.date("%H:%M", timestamp)

    if M.date ~= date or M.time ~= time then
        need_redraw = true
    else
        need_redraw = false
    end

    M.date = date
    M.time = time

    M.led_h = M.led_h + 2
    M.led_h = M.led_h % 360
    led.set_color_hsl({h = M.led_h, s = 1, l = 0.5})

    if (buttons.is_any_button_clicked()) then
        main_screen.change_module(main_menu_module)
    end
end

function M.draw()
    gdisplay.setfont(gdisplay.FONT_DEFAULT)
    gdisplay.write({ gdisplay.RIGHT, 64 - 16 }, M.date)

    gdisplay.setfont(gdisplay.FONT_7SEG)
    gdisplay.write({ 0, gdisplay.CENTER }, M.time)
end

return M
