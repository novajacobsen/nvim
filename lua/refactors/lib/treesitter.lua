local queries = {
  php = {
    classes = vim.treesitter.query.parse(
      "php",
      [[
(class_declaration
  name: (_) @name
  body: (_) @body
) @class
]]
    ),
  },
}

-- Grab matches from source using query parameters
-- returns a list of matches
local function find_all(source, query)
  local result = {}
  for index, match, metadata in query:iter_matches(source.node, source.buf) do
    local captures = {}
    for id, nodes in pairs(match) do
      captures[query.captures[id]] = nodes
    end

    result[index] = captures
  end

  return result
end

-- create object representing a selector on a source
local function selector(source)
  return {
    classes = function()
      local matches = find_all(source, source.queries.classes)
    end,
  }
end

-- create parser for given buffer using treesitter
return function(buf)
  local parser, err_parser = vim.treesitter.get_parser(buf)

  if not parser then
    vim.notify("Could not get parser: " .. err_parser, vim.log.levels.ERROR)
    return
  end

  local tree = parser:parse()[1]
  local lang = parser:lang()

  return {
    lang = lang,
    select = selector({
      queries = queries[lang],
      node = tree:root(),
      buf = buf,
    }),
  }
end
