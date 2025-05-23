print("Starting app")

main_screen = require("app.main_screen_state")
clock_module = require("app.clock_screen")
main_menu_module = require("app.main_menu")
quote_module = require("app.quote")
pomodoro_menu_module = require("app.pomodoro_menu")
pomodoro_work_module = require("app.pomodoro_work")
pomodoro_break_module = require("app.pomodoro_break")
pomodoro_done_menu_module = require("app.pomodoro_done_menu")

buttons = require("app.buttons")
buttons.setup()

led = require("app.led")
led.start_led()

main_screen.init_main_screen()

