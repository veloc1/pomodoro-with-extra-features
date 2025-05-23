local M = {
    cursor = 0,
    need_redraw = true,
}

function M.on_show()
    M.cursor = 0
    led.set_color({r = 20, g = 230, b = 70})
end

function M.update()
    M.need_redraw = false

    if (buttons.is_up_button_clicked()) then
        M.cursor = M.cursor - 1
        if M.cursor < 0 then
            M.cursor = 2
        end

        M.need_redraw = true
    end
    if (buttons.is_down_button_clicked()) then
        M.cursor = M.cursor + 1
        if M.cursor > 2 then
            M.cursor = 0
        end

        M.need_redraw = true
    end

    if (buttons.is_ok_button_clicked()) then
        if M.cursor == 0 then
            pomodoro_break_module.break_time_mins = 25
            main_screen.change_module(pomodoro_break_module)
        end
        if M.cursor == 1 then
            pomodoro_break_module.break_time_mins = 35
            main_screen.change_module(pomodoro_break_module)
        end
        if M.cursor == 2 then
            main_screen.change_module(main_menu_module)
        end
    end
end

function M.draw()
    gdisplay.setfont(gdisplay.FONT_DEFAULT)

    gdisplay.write({ gdisplay.CENTER, 0 }, "What to do now?")
    gdisplay.write({ 48, 16 }, " break 25")
    gdisplay.write({ 48, 32 }, " break 35")
    gdisplay.write({ 48, 48 }, " menu")

    gdisplay.write({ 36, 16 }, "  ")
    gdisplay.write({ 36, 32 }, "  ")
    gdisplay.write({ 36, 48 }, "  ")
    if (M.cursor == 0) then
        gdisplay.write({ 36, 16 }, ">")
    elseif (M.cursor == 1) then
        gdisplay.write({ 36, 32 }, ">")
    elseif (M.cursor == 2) then
        gdisplay.write({ 36, 48 }, ">")
    end
end

return M
