local M = {
    refresh_time = 0,
    quote = "",
    author = "",
    state = "init",
    qx = 128,
    need_redraw = true,
}

function M.load_quote()
    M.state = "loading"

    -- network is not working
    --[[
    thread.start(function()
        local url = "https://zenquotes.io/api/quotes/random"
        print("making request")
        local res, header, body = net.curl.get(url)
        print("request done")

        local response = cjson.decode(body)
        local quote = response[1]
    end)
    ]]--
    local f = io.open("/app/quotes.json", "r")
    local content = f:read("*all")
    f:close()

    local cjson = require("cjson")
    local quotes = cjson.decode(content)
    local quote = quotes[math.random(#quotes)]

    M.quote = quote.q
    M.author = quote.a

    M.state = "loaded"
    M.refresh_time = os.time()

    gdisplay.clear()

    M.qx = 128

    return content
end

function M.on_show()
    M.load_quote()
    led.set_color({r = 0, g = 215, b = 128})
end

function M.update()
    if os.time() > M.refresh_time + 60 * 60 * 24 then
        if M.state ~= "loading" then
            M.load_quote()
        end
    end

    if M.state == "loaded" then
        M.qx = M.qx - 2
        if M.qx == -1 or M.qx == -2 then
            M.qx = -4 -- workaround alignment constants
        end
        if M.qx == -4 then
            M.qx = -6 -- workaround alignment constants
        end

        local length = gdisplay.getfontsize() * string.len(M.quote) * 0.8
        if M.qx < -length then
            M.qx = 128
        end
    end

    if (buttons.is_any_button_clicked()) then
        main_screen.change_module(main_menu_module)
    end
end

function M.draw()
    gdisplay.setfont(gdisplay.FONT_DEFAULT)
    if M.state == "loading" then
        gdisplay.write({ gdisplay.CENTER, gdisplay.CENTER }, "Loading...")
    elseif M.state == "loaded" then
        gdisplay.write({ gdisplay.CENTER, gdisplay.BOTTOM }, M.author)

        gdisplay.setfont(gdisplay.FONT_MINYA24)
        gdisplay.write({ math.floor(M.qx), 12 }, M.quote)
        -- gdisplay.write({ gdisplay.CENTER, gdisplay.CENTER }, " quote")
    end

    gdisplay.rect({ 0, 33 }, 128, 2, gdisplay.BLACK) -- some fonts drawing with y offset. We dont clear entire screen, so sometimes pixels bleed out outside draw area of following char, and we get ugly underline after "g", "y" or any other chars with descents
    -- also this rect causes blinking on beforementioned chars.
end

return M
