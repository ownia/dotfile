rex.action({
    name = "apply_ghostty_settings",
    title = "Apply Ghostty Settings",
    run = function()
        rex.client.queue("client.setting.terminal.typography.font", { value = "Monaco" })
        rex.client.queue("client.setting.terminal.typography.size", { value = 13 })
        rex.client.queue("client.setting.terminal.advanced_fonts.fallback_fonts", { value = "PingFang SC" })
        rex.client.queue("client.setting.terminal.cursor.style", { value = "block" })
        rex.client.queue("client.setting.terminal.cursor.shaders", { value = true })
        rex.client.queue("client.setting.terminal.cursor.shader", { value = "warp" })
    end,
})
