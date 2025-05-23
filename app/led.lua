
local M = {}

function M.start_led()
    M.max_brigthness = 0.1
    M.color = {r = 255, g = 255, b = 255}
    local result = M.init_led()
    if (result) then
        M.start_thread()
    end
end

function M.init_led()
    M.led = neopixel.attach(neopixel.WS2812B, pio.GPIO5, 1)
    M.led:setPixel(0, 0, 0, 0)

    return true
end

function M.set_color(color)
    M.color = color
end

function hslToRgb(h, s, l)
    h = h / 360
    s = s / 100
    l = l / 100

    local r, g, b;

    if s == 0 then
        r, g, b = l, l, l; -- achromatic
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1 / 6 then return p + (q - p) * 6 * t end
            if t < 1 / 2 then return q end
            if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
            return p;
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s;
        local p = 2 * l - q;
        r = hue2rgb(p, q, h + 1 / 3);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1 / 3);
    end

    if not a then a = 1 end
    return r * 255, g * 255, b * 255, a * 255
end


function M.set_color_hsl(hsl)
    local r, g, b = hslToRgb(hsl.h, hsl.s * 100, hsl.l * 100)
    M.color = {r = r, g = g, b = b}
end

function M.start_thread()
    thread.start(function()
        print("started led")

        while true do
            M.step()
            tmr.delayms(32)
        end
    end)
end

function M.step()
    M.led:setPixel(0, math.floor(M.color.r * M.max_brigthness), math.floor(M.color.g * M.max_brigthness), math.floor(M.color.b * M.max_brigthness))
    M.led:update()
end

return M
