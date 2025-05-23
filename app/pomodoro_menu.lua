local M = {
    cursor = 0,
    need_redraw = true,
}

function M.on_show()
    M.cursor = 0
    led.set_color({r = 0, g = 128, b = 128})
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
            pomodoro_work_module.work_time_mins = 25
            main_screen.change_module(pomodoro_work_module)
        end
        if M.cursor == 1 then
            pomodoro_work_module.work_time_mins = 45
            main_screen.change_module(pomodoro_work_module)
        end
        if M.cursor == 2 then
            main_screen.change_module(main_menu_module)
        end
    end
end

function M.draw()
    gdisplay.setfont(gdisplay.FONT_DEFAULT)

    gdisplay.write({ gdisplay.CENTER, 0 }, "Set work period")
    gdisplay.write({ 48, 16 }, " 25 mins")
    gdisplay.write({ 48, 32 }, " 45 mins")
    gdisplay.write({ 48, 48 }, " back")

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
