-- Default config
-- Do not edit this file; it will be overwritten on package update

Editor.bind("normal", ":", "enter-command-mode")
Editor.bind("normal", "C-r", "reload-config")
Editor.bind("normal", "i", "enter-mode insert")
Editor.bind("normal", "h", "move-char-left")
Editor.bind("normal", "j", "move-char-down")
Editor.bind("normal", "k", "move-char-up")
Editor.bind("normal", "l", "move-char-right")
Editor.bind("normal", "H", "extend-char-left")
Editor.bind("normal", "J", "extend-char-down")
Editor.bind("normal", "K", "extend-char-up")
Editor.bind("normal", "L", "extend-char-right")
Editor.bind("normal", "g g", "goto-start")
Editor.bind("normal", "g e", "goto-end")
Editor.bind("normal", "g h", "goto-start-of-line")
Editor.bind("normal", "g l", "goto-end-of-line")
Editor.bind("normal", "g G", "extend-start")
Editor.bind("normal", "g E", "extend-end")
Editor.bind("normal", "g H", "extend-start-of-line")
Editor.bind("normal", "g L", "extend-end-of-line")
Editor.bind("normal", "u", "undo")
Editor.bind("normal", "U", "redo")
Editor.bind("normal", "y", "copy-kill-ring")
Editor.bind("normal", "p", "paste-kill-ring false")
Editor.bind("normal", "P", "paste-kill-ring true")

Editor.register_command("extend-selection-to-lines", "Extend current selection to entire lines", function()
    local view = Editor.get_active_view()
    if #(view:get_selections()) ~= 1 then
        return
    end

    local sel = view:get_selections()[1]

    sel.direction = "back"
    view:set_selections({sel})
    Editor.exec("extend-start-of-line")
    local sel = view:get_selections()[1]
    sel.direction = "forward"
    view:set_selections({sel})
    Editor.exec("extend-end-of-line")
end)
Editor.bind("normal", "x", "extend-selection-to-lines")

Editor.bind("normal", "%", "goto-start", "extend-end")

Editor.bind("normal", "d", "delete")
Editor.bind("normal", "c", "delete", "enter-mode insert")

Editor.bind("normal", "spc f", "open-file-tree")

Editor.register_command("open-file-tree", "Open file tree", function()
    local buffer = Editor.create_buffer()
    local view = Editor.create_view_for_buffer(buffer)
    Editor.set_active_view(view)
    -- pretend we got these through the filesystem
    local files = {
        "test.txt",
        "config.lua",
        "log.log",
        "Cargo.toml",
        "Cargo.lock",
    }
    for i, file in ipairs(files) do
        Editor.exec("insert \"" .. file .. "\\n\"")
    end
    Editor.exec("goto-start")
    Editor.exec("enter-mode file-tree")
    Editor.exec("extend-selection-to-lines")
end)

Editor.register_command("file-tree-open-current", "Open currently hovered file", function()
    local view = Editor.get_active_view()
    local sel = view:get_selections()[1]
    local path = sel:get_text()
    local path = path:gsub("%s+", "")
    Editor.exec("close-buffer")
    Editor.exec("enter-mode normal")
    Editor.open_file(path)
end)

Editor.bind("file-tree", "j", "move-char-down", "extend-selection-to-lines")
Editor.bind("file-tree", "k", "move-char-up", "extend-selection-to-lines")
Editor.bind("file-tree", "enter", "file-tree-open-current")

Editor.bind("insert", "bspc", "backspace")
Editor.bind("insert", "enter", "insert \"\\n\"")
Editor.bind("insert", "tab", "insert \"\\t\"")

Editor.bind("normal", "A-o", "tree-sitter-out")
Editor.bind("normal", "A-i", "tree-sitter-in")
Editor.bind("normal", "A-n", "tree-sitter-next")
Editor.bind("normal", "A-p", "tree-sitter-prev")
