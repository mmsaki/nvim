return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
      'mxsdev/nvim-dap-vscode-js',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local dap_python = require 'dap-python'

      require('dapui').setup {}
      require('nvim-dap-virtual-text').setup {
        commented = true, -- Show virtual text alongside comment
      }

      require('nvim-dap-virtual-text').setup {
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
            return '*****'
          end

          if #variable.value > 15 then
            return ' ' .. string.sub(variable.value, 1, 15) .. '... '
          end

          return ' ' .. variable.value
        end,
      }

      dap_python.setup 'python3'
      require('dap-vscode-js').setup {
        node_path = 'node', -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        -- debugger_path = '(runtimedir)/site/pack/packer/opt/vscode-js-debug', -- Path to vscode-js-debug installation.
        debugger_cmd = { 'js-debug-adapter' }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        -- adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
        -- log_file_path = '(stdpath cache)/dap_vscode_js.log', -- Path for file logging
        -- log_file_level = false, -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR, -- Logging level for output to console. Set to false to disable console output.
      }
      -- https://github.com/mxsdev/nvim-dap-vscode-js/issues/63
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}', --let both ports be the same for now...
        executable = {
          command = 'node',
          -- -- 💀 Make sure to update this path to point to your installation
          args = { vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
          -- command = "js-debug-adapter",
          -- args = { "${port}" },
        },
      }
      for _, language in ipairs { 'typescript', 'javascript' } do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Current File (pwa-node)',
            cwd = '${workspaceFolder}', -- vim.fn.getcwd(),
            args = { '${file}' },
            sourceMaps = true,
            protocol = 'inspector',
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Current File (Typescript)',
            cwd = '${workspaceFolder}',
            runtimeArgs = { '--loader=ts-node/esm' },
            program = '${file}',
            runtimeExecutable = 'node',
            -- args = { '${file}' },
            sourceMaps = true,
            protocol = 'inspector',
            outFiles = { '${workspaceFolder}/**/**/*', '!**/node_modules/**' },
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
        }
      end
      vim.fn.sign_define('DapBreakpoint', {
        text = '',
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })

      vim.fn.sign_define('DapBreakpointRejected', {
        text = '', -- or "❌"
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })

      vim.fn.sign_define('DapStopped', {
        text = '', -- or "→"
        texthl = 'DiagnosticSignWarn',
        linehl = 'Visual',
        numhl = 'DiagnosticSignWarn',
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      local opts = { noremap = true, silent = true }

      -- Toggle breakpoint
      vim.keymap.set('n', '<leader>db', function()
        dap.toggle_breakpoint()
      end, opts)

      -- Continue / Start
      vim.keymap.set('n', '<leader>dc', function()
        dap.continue()
      end, opts)

      -- Step Over
      vim.keymap.set('n', '<leader>do', function()
        dap.step_over()
      end, opts)

      -- Step Into
      vim.keymap.set('n', '<leader>di', function()
        dap.step_into()
      end, opts)

      -- Step Out
      vim.keymap.set('n', '<leader>dO', function()
        dap.step_out()
      end, opts)

      -- Keymap to terminate debugging
      vim.keymap.set('n', '<leader>dq', function()
        require('dap').terminate()
      end, opts)

      -- Toggle DAP UI
      vim.keymap.set('n', '<leader>du', function()
        dapui.toggle()
      end, opts)
    end,
  },
}
