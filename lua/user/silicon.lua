-- Requires silicon rust package

--┌────────────────────────┐
--│ cargo install silicon  │
--└────────────────────────┘

local status_ok, silicon = pcall(require, "silicon")
if not status_ok then
    return
end

silicon.setup({
    theme = "Dracula",
    output = string.format(
        "SILICON_%s-%s-%s_%s-%s.png",
        os.date("%Y"),
        os.date("%m"),
        os.date("%d"),
        os.date("%H"),
        os.date("%M")
    ), -- auto generate file name based on time (absolute or relative to cwd)
    bgColor = vim.g.terminal_color_5,
    bgImage = "", -- path to image, must be png
    roundCorner = true,
    windowControls = true,
    lineNumber = true,
    font = "monospace",
    lineOffset = 1, -- from where to start line number
    linePad = 2, -- padding between lines
    padHoriz = 80, -- Horizontal padding
    padVert = 100, -- vertical padding
    shadowBlurRadius = 10,
    shadowColor = "#555555",
    shadowOffsetX = 8,
    shadowOffsetY = 8,
}
)


--      Generate images of selected snippet.
-- require("silicon").visualise(false,false)
--
--Generate images of whole buffer with the selected snippet being highlighted by lighter background.
-- require("silicon").visualise(true,false)
--
-- Copy the image of snippet to clipboard. (Only xclip is supported for Linux, Mac and windows are also supported)
-- require("silicon").visualise(false,true)
--
-- PS: First argument tells whether to show whole buffer content and second tells whether to copy to clipboard.
