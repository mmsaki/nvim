local function is_dark_mode()
  -- macOS example: returns true if dark mode is enabled
  local result = vim.fn.system 'defaults read -g AppleInterfaceStyle 2>/dev/null'
  return result:match 'Dark' ~= nil
end

return {
  'catppuccin/nvim',
  dependencies = {
    { 'ellisonleao/gruvbox.nvim', lazy = false, priority = 1000, config = true },
  },
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    local dark_mode = is_dark_mode()
    dark_mode = true -- Force dark mode for testing purposes

    if dark_mode then
      require('catppuccin').setup {
        background = {
          dark = 'mocha',
        },
        color_overrides = {
          mocha = {
            base = '#000000',
            mantle = '#000000',
            crust = '#000000',
          },
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    else
      require('gruvbox').setup {
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = 'hard', -- can be "hard", "soft" or empty string
        palette_overrides = {},
        -- overrides = {
        --   ['@lsp.type.method'] = { bg = '#ff9900' },
        --   ['@comment.lua'] = { bg = '#000000' },
        -- },
        dim_inactive = false,
        transparent_mode = false,
      }
      vim.cmd 'colorscheme gruvbox'
    end
  end,
}
-- return { -- You can easily change to a different colorscheme.
--   -- Change the name of the colorscheme plugin below, and then
--   -- change the command in the config to whatever the name of that colorscheme is.
--   --
--   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--   'folke/tokyonight.nvim',
--   priority = 1000, -- Make sure to load this before all the other start plugins.
--   init = function()
--     -- Load the colorscheme here.
--     -- Like many other themes, this one has different styles, and you could load
--     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--     vim.cmd.colorscheme 'tokyonight-night'
--
--     -- You can configure highlights by doing something like:
--     vim.cmd.hi 'Comment gui=none'
--   end,
-- }
