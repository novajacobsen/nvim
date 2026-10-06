return {
  {
    "stevearc/conform.nvim",
    opts = {
      log_level = vim.log.levels.DEBUG,
      formatters = {
        prettier = {
          prepend_args = function()
            return {
              "--single-quote",
              "--tab-width=2",
              "--trailing-comma=all",
              "--no-semi",
            }
          end,
        },
      },
    },
  },
}
