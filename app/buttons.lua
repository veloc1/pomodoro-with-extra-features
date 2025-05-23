local M = {}

PIN_BTN_UP = 27
PIN_BTN_DOWN = 26
PIN_BTN_OK = 25

function button_state(pin)
    pio.pin.setdir(pio.INPUT, pin)

    return {
        pin = pin,
        clicked = false,
        handled = false,
        reset_time = 0,
    }
end


function M.setup()
    M.buttons = {
        up = button_state(PIN_BTN_UP),
        down = button_state(PIN_BTN_DOWN),
        ok = button_state(PIN_BTN_OK),
    }

    M.thread = thread.start(function()
        print("started buttons thread")

        while true do
            M.step()
            tmr.delayms(64)
        end
    end)
end

function M.is_button_clicked(button_state)
    local r = button_state.clicked and not button_state.handled
    button_state.handled = true
    return r
end

function M.is_up_button_clicked()
    return M.is_button_clicked(M.buttons.up)
end

function M.is_down_button_clicked()
    return M.is_button_clicked(M.buttons.down)
end

function M.is_ok_button_clicked()
    return M.is_button_clicked(M.buttons.ok)
end

function M.is_any_button_clicked()
    return M.is_button_clicked(M.buttons.up) or M.is_button_clicked(M.buttons.down) or M.is_button_clicked(M.buttons.ok)
end

function M.step()
    for key, state in pairs(M.buttons) do
        local value = pio.pin.getval(state.pin)

        if (state.clicked == false and value == 1) then
            state.clicked = true
            state.handled = false
            state.reset_time = os.clock() + 0.2
        elseif (state.clicked == false and value == 0) then
            -- do nothing?
        elseif (state.clicked == true and value == 1) then
            state.reset_time = os.clock() + 0.2
        elseif (state.clicked == true and value == 0) then
            -- wait reset time
        end

        if (state.clicked) then
            if (state.handled) then
                -- do nothing
            end

            if (state.reset_time < os.clock()) then
                state.clicked = false
                state.hanlded = false
            end
        end
    end
end

return M
