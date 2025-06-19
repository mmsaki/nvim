return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'creativenull/efmls-configs-nvim',
      version = 'v1.x.x',
    },
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities prskvided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
    { 'folke/neoconf.nvim' },
  },
  config = function()
    -- Change diagnostic symbols in the sign column (gutter)
    if vim.g.have_nerd_font then
      local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
      local diagnostic_signs = {}
      for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      end
      vim.diagnostic.config { signs = { text = diagnostic_signs } }
    end

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      rust_analyzer = {},
      ts_ls = {},
      lua_ls = {},
      ruff = {},
      pyright = {},
      html = {},
      cssls = {},
      tailwindcss = {},
      solidity_ls_nomicfoundation = {},
      biome = {},
      dockerls = {},
      debugpy = {},
      mdformat = {},
      markdownlint = {},
      stylua = {},
      -- firefox_debug_adapter = {},
      -- chrome_debug_adapter = {},
      -- bash_debug_adapter = {},
      -- js_debug_adapter = {},
      -- local_lua_debugger_vscode = {},
      -- lua_language_server = {},
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()
    require('neoconf').setup {}
    local mason = require 'mason'
    mason.setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'ts_ls',
        'ruff',
        'pyright',
        'html',
        'cssls',
        'tailwindcss',
        'solidity_ls_nomicfoundation',
        'biome',
        'dockerls',
      },
    }
    local lspconfig = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    lspconfig.lua_ls.setup { capabilities = capabilities }
    lspconfig.ts_ls.setup { capabilities = capabilities }
    lspconfig.tailwindcss.setup { capabilities = capabilities }
    lspconfig.rust_analyzer.setup { capabilities = capabilities }
    lspconfig.ruff.setup { capabilities = capabilities }
    lspconfig.pyright.setup { capabilities = capabilities }
    lspconfig.cssls.setup { capabilities = capabilities }
    lspconfig.html.setup { capabilities = capabilities }
    lspconfig.biome.setup { capabilities = capabilities }
    lspconfig.dockerls.setup { capabilities = capabilities }
    lspconfig.solidity_ls_nomicfoundation.setup { capabilities = capabilities }
    lspconfig.sourcekit.setup {
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      },
    }
    local languages = {
      javascript = {
        require 'efmls-configs.linters.eslint',
        require 'efmls-configs.formatters.prettier_d',
      },
      javascriptreact = {
        require 'efmls-configs.linters.eslint',
        require 'efmls-configs.formatters.prettier_d',
      },
      typescript = {
        require 'efmls-configs.linters.eslint',
        require 'efmls-configs.formatters.prettier_d',
      },
      typescriptreact = {
        require 'efmls-configs.linters.eslint',
        require 'efmls-configs.formatters.prettier_d',
      },
      solidity = {
        require 'efmls-configs.linters.solhint',
        require 'efmls-configs.formatters.forge_fmt',
      },
      lua = {
        require 'efmls-configs.formatters.stylua',
      },
      python = {
        require 'efmls-configs.linters.ruff',
        require 'efmls-configs.formatters.ruff',
      },
      rust = {
        require 'efmls-configs.formatters.rustfmt',
      },
      dockerfile = {
        require 'efmls-configs.linters.hadolint',
      },
      json = {
        require 'efmls-configs.linters.jq',
        require 'efmls-configs.formatters.jq',
      },
      markdown = {
        require 'efmls-configs.linters.markdownlint',
        require 'efmls-configs.formatters.mdformat',
      },
    }
    local efmls_config = {
      filetypes = vim.tbl_keys(languages),
      settings = {
        rootMarkers = { '.git/' },
        languages = languages,
      },
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        hover = true,
        completion = true,
        codeAction = true,
        documentSymbol = true,
      },
    }
    lspconfig.efm.setup(vim.tbl_extend('force', efmls_config, {
      capabilities = capabilities,
    }))

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })
  end,
}
