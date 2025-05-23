.deploy/wcc.exe -p COM4 -up "app.lua" "/app.lua"
foreach ($item in Get-ChildItem -Path "app" -Recurse -Filter "*.lua") {
    "Deploing app/$($item.Name)"
    .deploy/wcc.exe -p COM4 -up "app/$($item.Name)" "/app/$($item.Name)"
    "Done `n"
}

putty -load "esp-pomodoro"
