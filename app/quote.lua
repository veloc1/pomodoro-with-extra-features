local M = {
    refresh_time = 0,
    quote = "",
    author = "",
    state = "init",
    page = 0,
    pages = 0,
    need_redraw = true,
    lines_per_page = 5,
    lines = {},
    chars_per_line = 0,
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

    M.page = 0
    gdisplay.setfont(gdisplay.FONT_DEFAULT)
    local xsize, ysize = gdisplay.getfontsize()
    M.chars_per_line = 16 -- math.floor(128 / xsize)
    M.lines = {}

    local line_tmp = ""

    for word in string.gmatch(M.quote, "[^%s]+") do
        if #line_tmp + #word > M.chars_per_line then
            table.insert(M.lines, line_tmp)
            line_tmp = nil
            line_tmp = ""
        end

        line_tmp = line_tmp .. word .. " "
    end
    table.insert(M.lines, line_tmp)

    M.pages = math.floor(#M.lines / M.lines_per_page + 1)

    M.state = "loaded"
    M.refresh_time = os.time()

    gdisplay.clear()
    M.need_redraw = true

    return content
end

function M.on_show()
    M.load_quote()
    led.set_color({r = 0, g = 215, b = 128})
end

function M.update()
    M.need_redraw = false
    if os.time() > M.refresh_time + 60 * 60 * 24 then
        if M.state ~= "loading" then
            M.load_quote()
        end
    end

    if M.state == "loaded" then
    end

    if (buttons.is_ok_button_clicked()) then
        main_screen.change_module(main_menu_module)
    end
    if (buttons.is_up_button_clicked()) then
        M.page = M.page - 1

        if M.page < 0 then
            M.page = M.pages
        end
        gdisplay.clear()
        M.need_redraw = true
    end
    if (buttons.is_down_button_clicked()) then
        M.page = M.page + 1

        if M.page > M.pages then
            M.page = 0
        end
        gdisplay.clear()
        M.need_redraw = true
    end
end

function M.draw()
    gdisplay.setfont(gdisplay.FONT_DEFAULT)
    if M.state == "loading" then
        gdisplay.write({ gdisplay.CENTER, gdisplay.CENTER }, "Loading...")
    elseif M.state == "loaded" then
        print("a")
        print(M.page)
        print(M.pages)
        if M.page == M.pages then
            -- last page for author
            gdisplay.write({ gdisplay.RIGHT, gdisplay.BOTTOM }, M.author)
        else
            for i = 1, M.lines_per_page do
                local line = M.lines[M.page * M.lines_per_page + i]
                local y = (i - 1) * 12
                gdisplay.write({ 0, y }, line)
            end
        end
    end
end

return M
