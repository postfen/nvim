local M = {}

local merge_tb = vim.tbl_deep_extend

vim.cmd([[
  function Test()
    %SnipRun
    call feedkeys("\<esc>`.")
  endfunction

  function TestI()
    let b:caret = winsaveview()
    %SnipRun
    call winrestview(b:caret)
  endfunction
]])

M.load_override = function(default_table, plugin_name)
    local user_table = M.load_config().plugins.override[plugin_name] or {}
    user_table = type(user_table) == "table" and user_table or user_table()
    return merge_tb("force", default_table, user_table) or {}
end

function M.sniprun_enable()
    vim.cmd([[
    %SnipRun

    augroup _sniprun
     autocmd!
     autocmd TextChanged * call Test()
     autocmd TextChangedI * call TestI()
    augroup end
  ]])
    vim.notify("Enabled SnipRun")
end

function M.disable_sniprun()
    M.remove_augroup("_sniprun")
    vim.cmd([[
    SnipClose
    SnipTerminate
    ]])
    vim.notify("Disabled SnipRun")
end

function M.toggle_sniprun()
    if vim.fn.exists("#_sniprun#TextChanged") == 0 then
        M.sniprun_enable()
    else
        M.disable_sniprun()
    end
end

function M.remove_augroup(name)
    if vim.fn.exists("#" .. name) == 1 then
        vim.cmd("au! " .. name)
    end
end

vim.cmd([[ command! SnipRunToggle execute 'lua require("user.functions").toggle_sniprun()' ]])

-- get length of current word
function M.get_word_length()
    local word = vim.fn.expand("<cword>")
    return #word
end

function M.toggle_option(option)
    local value = not vim.api.nvim_get_option_value(option, {})
    vim.opt[option] = value
    vim.notify(option .. " set to " .. tostring(value))
end

function M.toggle_tabline()
    local value = vim.api.nvim_get_option_value("showtabline", {})

    if value == 2 then
        value = 0
    else
        value = 2
    end

    vim.opt.showtabline = value

    vim.notify("showtabline" .. " set to " .. tostring(value))
end

local diagnostics_active = true
function M.toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end

function M.isempty(s)
    return s == nil or s == ""
end

function M.get_buf_option(opt)
    local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
    if not status_ok then
        return nil
    else
        return buf_option
    end
end

function M.smart_quit()
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    if modified then
        vim.ui.input({
            prompt = "You have unsaved changes. Quit anyway? (y/n) ",
        }, function(input)
            if input == "y" then
                vim.cmd("q!")
            end
        end)
    else
        vim.cmd("q!")
    end
end

function M.daylight()
    if tonumber(os.date("%H")) < 17 and 9 <= tonumber(os.date("%H")) then
        return true
    else
        return false
    end
end

-- //TODO: Get Align mapped to whichkey
function M.align_by_char()
    require("align").align_to_char(1, true)
end

return M
