return {
  run = function(name)
    local Context = require("refactors.lib.context")
    local ok, refactor = pcall(require, "refactors." .. name)

    if not ok then
      vim.notify("Unknown refactor: " .. name, vim.log.levels.ERROR)
      return
    end

    if type(refactor.apply) ~= "function" then
      vim.notify(name .. " has no apply() function", vim.log.levels.ERROR)
      return
    end

    refactor.apply(Context.new(vim.api.nvim_get_current_buf()))
  end,
}
