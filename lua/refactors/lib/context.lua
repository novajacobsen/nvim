local Context = {}

local function buffer(arg)
  local buf = arg or vim.api.nvim_get_current_buf()

  if type(arg) == "string" then
    local path = vim.fn.fnameescape(arg)
    buf = vim.fn.bufnr(path)

    if buf == -1 then
      vim.notify("Found no buffer for " .. arg)
      return
    end
  end

  if not vim.api.nvim_buf_is_valid(buf) then
    vim.notify("Invalid buffer:" + buf)
    return
  end

  if not vim.api.nvim_buf_is_loaded(buf) then
    vim.fn.bufload(buf)
  end

  return buf
end

function Context.new(source)
  local buf = buffer(source)
  if not buf then
    return
  end

  local parser = require("refactors.lib.treesitter")(buf)
  if not parser then
    vim.notify("Parser failed to instantiate")
    return
  end

  return {
    lang = parser.lang,
    select = parser.select,
    delete = function(selection)
      PP(selection)
    end,
    append = function(text, selection)
      vim.notify("Appending some text")
    end,
  }
end

local function test()
  local ctx = Context.new(vim.fn.stdpath("config") .. "/lua/refactors/example/boot.php")
  if not ctx then
    return
  end

  local class = ctx.select.classes()
  PP(class)
end

test()
