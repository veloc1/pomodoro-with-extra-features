local M = {
    state = "work",
    need_redraw = true,
    work_time_mins = 1,
    remaining_seconds = 1,
    start_time = 0,
    time = "",
}

function M.on_show()
    M.state = "work"
    M.remaining_seconds = M.work_time_mins * 60
    M.time = tostring(M.work_time_mins) .. ":" .. "00"
    M.start_time = os.time()

    led.set_color({r = 20, g = 128, b = 225})
end

function M.update()
    M.need_redraw = false
    if M.state == "done" then

        if (buttons.is_ok_button_clicked()) then
            main_screen.change_module(pomodoro_done_menu_module)
        end
    elseif M.state == "work" then
        local time = ""
        local passed = os.time() - M.start_time

        local rem = M.remaining_seconds - passed


        local mins = math.floor(rem / 60)
        if mins < 10 then
            mins = "0" .. tostring(mins)
        end
        local secs = rem % 60
        if secs < 10 then
            secs = "0" .. tostring(secs)
        end

        time = tostring(mins) .. ":" .. tostring(secs)

        if M.time ~= time  then
            M.need_redraw = true
        else
            M.need_redraw = false
        end

        M.time = time

        if rem <= 0 then
            M.state = "done"
            gdisplay.clear()
            M.need_redraw = true
            led.set_color({r = 20, g = 230, b = 70})
        end

        if (buttons.is_ok_button_clicked()) then
            M.state = "abort"
            gdisplay.clear()
            M.need_redraw = true
            led.set_color({r = 200, g = 190, b = 70})
        end
    elseif M.state == "abort" then
        if (buttons.is_ok_button_clicked()) then
            main_screen.change_module(main_menu_module)
        end
        if buttons.is_up_button_clicked() or buttons.is_down_button_clicked() then
            M.state = "work"
            gdisplay.clear()
            M.need_redraw = true
            led.set_color({r = 20, g = 128, b = 225})
        end
    end


end

function M.draw()
    if M.state == "work" then
        gdisplay.setfont(gdisplay.FONT_7SEG)
        gdisplay.write({ gdisplay.CENTER, gdisplay.CENTER }, M.time)
    elseif M.state == "abort" then
        gdisplay.setfont(gdisplay.FONT_DEFAULT)
        gdisplay.write({ gdisplay.CENTER, 0 }, "To abort period")
        gdisplay.write({ gdisplay.CENTER, 12 }, "press OK button")
        gdisplay.write({ gdisplay.CENTER, 24 }, " again")
    elseif M.state == "done" then
        gdisplay.setfont(gdisplay.FONT_DEFAULT)
        gdisplay.write({ gdisplay.CENTER, 0 }, "Congratulations!")
        gdisplay.write({ gdisplay.CENTER, 24 }, "Work period")
        gdisplay.write({ gdisplay.CENTER, 36 }, "is done")
    end
end

return M
