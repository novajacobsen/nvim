-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Save on buffer leave
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! update")
    end
  end,
})

-- `:Refac refactorName` to run a custom refactoring
vim.api.nvim_create_user_command("Refac", function(opts)
  require("refactors").run(opts.args)
end, {
  nargs = 1,
  complete = function()
    local files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/refactors", ".lua", false, true)
    local results = {}
    for _, file in ipairs(files) do
      table.insert(results, vim.fn.fnamemodify(file, ":t:r"))
    end
    return results
  end,
})

-- Lua helper functions

-- pretty print an object to vim notify
function PP(object)
  local function dump(obj, depth)
    depth = depth or 0
    local newl = "\n" .. string.rep("  ", depth)
    if type(obj) == "table" then
      local str = "{" .. newl
      for k, v in pairs(obj) do
        str = str .. "  [" .. k .. "] = " .. dump(v, depth + 1) .. "," .. newl
      end
      return str .. "}" .. newl
    end
    return tostring(obj) .. newl
  end
  vim.notify(dump(object), vim.log.levels.INFO)
end
