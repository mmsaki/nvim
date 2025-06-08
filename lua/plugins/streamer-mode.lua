return {
  'Kolkhis/streamer-mode.nvim',
  config = function()
    require('streamer-mode').setup {
      default_state = 'on',
      paths = {
        '*/dotenv/*',
        '*/.env',
        '*/.env*',
        '*.c',
        '~/.bash*',
        '~/.zsh*',
        '~/.dotfiles/*',
        '~/.my_config/*',
        '~/.zshrc',
        '*/.gitconfig',
      },
    }
  end,
}
