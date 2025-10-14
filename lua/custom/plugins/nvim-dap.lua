---@diagnostic disable: missing-parameter
return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    config = function()
      local dap = require 'dap'
      -- require('dap.ext.vscode').load_launchjs(vim.fn.expand '~' .. '/dotfiles/.config/vscode/launch.json', { cppdbg = { 'python', 'qmt' } })

      -- NOTE: configure adapters
      dap.adapters.codelldb = {
        type = 'executable',
        command = 'codelldb', -- or if not in $PATH: "/absolute/path/to/codelldb"

        -- On windows you may have to uncomment this:
        -- detached = false,
      }

      -- dap.adapters.cppdbg = {
      --   id = 'cppdbg',
      --   type = 'executable',
      --   command = 'OpenDebugAD7', -- or if not in $PATH: "/absolute/path/to/OpenDebugAD7"
      --   options = { detached = false },
      -- }
      --
      -- dap.adapters.gdb = {
      --   type = 'executable',
      --   command = 'gdb',
      --   args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
      -- }

      -- dap.adapters.cudagdb = {
      --   type = 'executable',
      --   command = 'cuda-gdb',
      -- }

      -- NOTE: filetype configurations

      -- dap.configurations.cuda = {
      --   {
      --     name = 'Launch (cuda-gdb)',
      --     type = 'cudagdb',
      --     request = 'launch',
      --     program = function()
      --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      --     end,
      --     cwd = '${workspaceFolder}',
      --     stopOnEntry = false,
      --   },
      --   {
      --     name = 'Launch (gdb)',
      --     type = 'cppdbg',
      --     MIMode = 'gdb',
      --     request = 'launch',
      --     miDebuggerPath = '/usr/bin/gdb',
      --     program = function()
      --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      --     end,
      --     cwd = '${workspaceFolder}',
      --     setupCommands = {
      --       {
      --         description = 'Enable pretty-printing for gdb',
      --         ignoreFailures = true,
      --         text = '-enable-pretty-printing',
      --       },
      --     },
      --     stopAtBeginningOfMainSubprogram = false,
      --   },
      -- }
      dap.configurations.cpp = dap.configurations.cpp or {}

      vim.list_extend(dap.configurations.cpp, {
        {
          name = 'Launch (codelldb)',
          type = 'codelldb',
          request = 'launch',
          -- program = function()
          --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          -- end,
          -- * Use 'debug' as the default progrom name
          program = '${workspaceFolder}' .. '/debug',
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
        -- {
        --   name = 'Launch (gdb)',
        --   type = 'cppdbg',
        --   MIMode = 'gdb',
        --   request = 'launch',
        --   miDebuggerPath = '/usr/bin/gdb',
        --   program = function()
        --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --   end,
        --   cwd = '${workspaceFolder}',
        --   setupCommands = {
        --     {
        --       description = 'Enable pretty-printing for gdb',
        --       ignoreFailures = true,
        --       text = '-enable-pretty-printing',
        --     },
        --   },
        --   stopAtBeginningOfMainSubprogram = false,
        -- },
        -- {
        --   name = 'Select and attach to process',
        --   type = 'cppdbg',
        --   request = 'attach',
        --   program = function()
        --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --   end,
        --   pid = function()
        --     local name = vim.fn.input 'Executable name (filter): '
        --     return require('dap.utils').pick_process { filter = name }
        --   end,
        --   cwd = '${workspaceFolder}',
        -- },
      })

      dap.configurations.python = dap.configurations.python or {}
      vim.list_extend(dap.configurations.python, {
        {
          type = 'python',
          request = 'launch',
          name = 'file:args (cwd)',
          program = '${file}',
          args = function()
            local args_string = vim.fn.input 'Arguments: '
            local utils = require 'dap.utils'
            if utils.splitstr and vim.fn.has 'nvim-0.10' == 1 then
              return utils.splitstr(args_string)
            end
            return vim.split(args_string, ' +')
          end,
          console = 'integratedTerminal',
          cwd = vim.fn.getcwd(),
        },
        {
          MIMode = 'gdb',
          args = {
            '${workspaceFolder}/Gaudi/Gaudi/scripts/gaudirun.py',
            '${file}',
          },
          cwd = '${fileDirname}',
          externalConsole = false,
          miDebuggerPath = '${workspaceFolder}/Moore/gdb',
          name = 'GDB: gaudirun.py (Moore)',
          program = function()
            local result = vim.system({ 'utils/run-env', 'Gaudi', 'which', 'python3' }, { text = true }):wait()
            return vim.trim(result.stdout)
          end,
          request = 'launch',
          setupCommands = {
            {
              description = 'Enable pretty-printing for gdb',
              ignoreFailures = true,
              text = '-enable-pretty-printing',
            },
          },
          type = 'cppdbg',
          preLaunchTask = 'make fast/Rec',
        },
        {
          MIMode = 'gdb',
          args = {
            '${workspaceFolder}/Gaudi/Gaudi/scripts/gaudirun.py',
            '${file}',
          },
          cwd = '${fileDirname}',
          externalConsole = false,
          -- miDebuggerPath = '${workspaceFolder}/${input:lhcbProject}/gdb',
          miDebuggerPath = function()
            local project = vim.fn.input('Project name: ', 'Moore')
            return '${workspaceFolder}/' .. project .. '/gdb'
          end,
          name = 'GDB: gaudirun.py',
          program = function()
            local result = vim.system({ 'utils/run-env', 'Gaudi', 'which', 'python3' }, { text = true }):wait()
            return vim.trim(result.stdout)
          end,
          request = 'launch',
          setupCommands = {
            {
              description = 'Enable pretty-printing for gdb',
              ignoreFailures = true,
              text = '-enable-pretty-printing',
            },
          },
          type = 'cppdbg',
        },
        {
          MIMode = 'gdb',
          args = {
            'qmtexec',
            '${file}',
          },
          cwd = '${fileDirname}',
          externalConsole = false,
          miDebuggerPath = '${workspaceFolder}/Gaudi/gdb',
          name = 'GDB: qmtexec',
          program = function()
            local project = vim.fn.input('Project name: ', 'Moore')
            return '${workspaceFolder}/' .. project .. '/run'
          end,
          request = 'launch',
          setupCommands = {
            {
              description = 'Enable pretty-printing for gdb',
              ignoreFailures = true,
              text = '-enable-pretty-printing',
            },
          },
          type = 'cppdbg',
        },
        {
          MIMode = 'gdb',
          miDebuggerPath = '${workspaceFolder}/Gaudi/Gaudi/gdb',
          name = 'GDB: attach',
          processId = '${command:pickProcess}',
          program = '/cvmfs/lhcb.cern.ch/lib/lcg/releases/Python/3.9.12-9a1bc/x86_64-el9-gcc13-opt/bin/python',
          request = 'attach',
          setupCommands = {
            {
              description = 'Enable pretty-printing for gdb',
              ignoreFailures = true,
              text = '-enable-pretty-printing',
            },
          },
          type = 'cppdbg',
        },
      })
      dap.configurations.qmt = dap.configurations.python
    end,
  },
  -- {
  --   'rcarriga/nvim-dap-ui',
  --   dependencies = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text', 'nvim-neotest/nvim-nio' },
  --   -- keys = {
  --   --   '<leader>db',
  --   --   '<leader>ds',
  --   --   '<leader>du',
  --   --   '<F1>',
  --   --   '<F2>',
  --   --   '<F3>',
  --   --   '<F4>',
  --   --   '<F5>',
  --   --   '<F6>',
  --   --   '<F7>',
  --   -- },
  --   config = function()
  --     require('nvim-dap-virtual-text').setup {} -- optional
  --     local ok, noice = pcall(require, 'noice')
  --     if ok then
  --       noice.setup()
  --     end
  --
  --     local custom_utils = {}
  --     custom_utils.reset_overseerlist_width = function()
  --       for _, win in ipairs(vim.api.nvim_list_wins()) do
  --         local buf = vim.api.nvim_win_get_buf(win)
  --         local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
  --         if ft == 'OverseerList' then
  --           local target_width = math.floor(vim.o.columns * 0.2)
  --           vim.api.nvim_win_set_width(win, target_width)
  --           break
  --         end
  --       end
  --     end
  --     -- UI responsiveness
  --     local dap, dapui = require 'dap', require 'dapui'
  --     dap.listeners.before.attach.dapui_config = function()
  --       dapui.open { reset = true }
  --       custom_utils.reset_overseerlist_width()
  --     end
  --     dap.listeners.before.launch.dapui_config = function()
  --       dapui.open { reset = true }
  --       custom_utils.reset_overseerlist_width()
  --     end
  --     -- dap.listeners.before.event_terminated.dapui_config = function()
  --     --   dapui.close()
  --     -- end
  --     -- dap.listeners.before.event_exited.dapui_config = function()
  --     --   dapui.close()
  --     -- end
  --
  --     -- customize UI layout
  --     dapui.setup {
  --       expand_lines = false,
  --       layouts = {
  --         {
  --           position = 'left',
  --           size = 0.2,
  --           elements = {
  --             { id = 'stacks', size = 0.2 },
  --             { id = 'scopes', size = 0.5 },
  --             { id = 'breakpoints', size = 0.15 },
  --             { id = 'watches', size = 0.15 },
  --           },
  --         },
  --         {
  --           position = 'bottom',
  --           size = 0.2,
  --           elements = {
  --             { id = 'repl', size = 0.3 },
  --             { id = 'console', size = 0.7 },
  --           },
  --         },
  --       },
  --     }
  --
  --     -- Custom breakpoint icons
  --     vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
  --     vim.fn.sign_define(
  --       'DapBreakpointCondition',
  --       { text = '', texthl = 'DapBreakpointCondition', linehl = 'DapBreakpointCondition', numhl = 'DapBreakpointCondition' }
  --     )
  --     vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
  --
  --     -- keymaps
  --     vim.keymap.set('n', '<leader>du', function()
  --       dapui.toggle { reset = true }
  --       custom_utils.reset_overseerlist_width()
  --     end, { desc = 'DAP: Toggle UI' })
  --     vim.keymap.set('n', '<F1>', function()
  --       dapui.toggle { reset = true }
  --       custom_utils.reset_overseerlist_width()
  --     end, { desc = 'DAP: Toggle UI' })
  --     vim.keymap.set('n', '<leader>ds', dap.continue, { desc = ' Start/Continue' })
  --     vim.keymap.set('n', '<F2>', dap.continue, { desc = ' Start/Continue' })
  --     vim.keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step into' })
  --     vim.keymap.set('n', '<F3>', dap.step_into, { desc = ' Step into' })
  --     vim.keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step over' })
  --     vim.keymap.set('n', '<F4>', dap.step_over, { desc = ' Step over' })
  --     vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = ' Step out' })
  --     vim.keymap.set('n', '<F5>', dap.step_out, { desc = ' Step out' })
  --     vim.keymap.set('n', '<leader>dq', dap.close, { desc = 'DAP: Close session' })
  --     vim.keymap.set('n', '<leader>dr', dap.restart_frame, { desc = 'DAP: Restart frame' })
  --     vim.keymap.set('n', '<F6>', dap.restart, { desc = 'DAP: Start over' })
  --     -- vim.keymap.set('n', '<F6>', function()
  --     --   pcall(function() dap.terminate() end)
  --     --   vim.defer_fn(function()
  --     --   pcall(function() dap.continue() end)
  --     --   end, 500)
  --     -- end, { desc = 'DAP: Start over' })
  --     vim.keymap.set('n', '<leader>dQ', dap.terminate, { desc = ' Terminate session' })
  --     vim.keymap.set('n', '<F7>', dap.terminate, { desc = ' Terminate session' })
  --
  --     vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'DAP: Run to Cursor' })
  --     vim.keymap.set('n', '<leader>dR', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })
  --     vim.keymap.set('n', '<leader>dh', require('dap.ui.widgets').hover, { desc = 'DAP: Hover' })
  --
  --     vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Breakpoint' })
  --     vim.keymap.set('n', '<leader>dB', function()
  --       local input = vim.fn.input 'Condition for breakpoint:'
  --       dap.set_breakpoint(input)
  --     end, { desc = 'DAP: Conditional Breakpoint' })
  --     vim.keymap.set('n', '<leader>dD', dap.clear_breakpoints, { desc = 'DAP: Clear Breakpoints' })
  --
  --     -- * compile current .cpp file with debug mode
  --     vim.keymap.set('n', '<leader>dm', '<cmd>!clang++ % -o debug -g<CR>', { desc = 'DAP: Breakpoint' })
  --   end,
  -- },
  -- { -- python debugger
  --   'mfussenegger/nvim-dap-python',
  --   dependencies = {
  --     'mfussenegger/nvim-dap',
  --     'rcarriga/nvim-dap-ui',
  --   },
  --   keys = {
  --     { '<leader>db', ft = 'python' },
  --     { '<leader>ds', ft = 'python' },
  --     { '<leader>du', ft = 'python' },
  --   },
  --   config = function()
  --     local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
  --     require('dap-python').setup(path)
  --   end,
  -- },
  {
    'igorlfs/nvim-dap-view',
    ---@module 'dap-view'
    ---@type dapview.Config
    dependencies = { 'mfussenegger/nvim-dap', 'theHamsta/nvim-dap-virtual-text', 'nvim-neotest/nvim-nio' },
    opts = {
      winbar = {
        show = true,
        -- You can add a "console" section to merge the terminal with the other views
        sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl' },
        -- Must be one of the sections declared above
        default_section = 'watches',
        -- Configure each section individually
        base_sections = {
          breakpoints = {
            keymap = 'B',
            label = 'Breakpoints [B]',
            short_label = ' [B]',
            action = function()
              require('dap-view.views').switch_to_view 'breakpoints'
            end,
          },
          scopes = {
            keymap = 'S',
            label = 'Scopes [S]',
            short_label = '󰂥 [S]',
            action = function()
              require('dap-view.views').switch_to_view 'scopes'
            end,
          },
          exceptions = {
            keymap = 'E',
            label = 'Exceptions [E]',
            short_label = '󰢃 [E]',
            action = function()
              require('dap-view.views').switch_to_view 'exceptions'
            end,
          },
          watches = {
            keymap = 'W',
            label = 'Watches [W]',
            short_label = '󰛐 [W]',
            action = function()
              require('dap-view.views').switch_to_view 'watches'
            end,
          },
          threads = {
            keymap = 'T',
            label = 'Threads [T]',
            short_label = '󱉯 [T]',
            action = function()
              require('dap-view.views').switch_to_view 'threads'
            end,
          },
          repl = {
            keymap = 'R',
            label = 'REPL [R]',
            short_label = '󰯃 [R]',
            action = function()
              require('dap-view.repl').show()
            end,
          },
          sessions = {
            keymap = 'K', -- I ran out of mnemonics
            label = 'Sessions [K]',
            short_label = ' [K]',
            action = function()
              require('dap-view.views').switch_to_view 'sessions'
            end,
          },
          console = {
            keymap = 'C',
            label = 'Console [C]',
            short_label = '󰆍 [C]',
            action = function()
              require('dap-view.views').switch_to_view 'console'
            end,
          },
        },
        -- Add your own sections
        custom_sections = {},
        controls = {
          enabled = true,
          position = 'right',
          buttons = {
            'play',
            'step_into',
            'step_over',
            'step_out',
            'step_back',
            'run_last',
            'terminate',
            'disconnect',
          },
          custom_buttons = {},
        },
      },
      windows = {
        height = 0.25,
        position = 'below',
        terminal = {
          width = 0.5,
          position = 'right',
          -- List of debug adapters for which the terminal should be ALWAYS hidden
          hide = {},
          -- Hide the terminal when starting a new session
          start_hidden = true,
        },
      },
      icons = {
        disabled = '',
        disconnect = '',
        enabled = '',
        filter = '󰈲',
        negate = ' ',
        pause = '',
        play = '',
        run_last = '',
        step_back = '',
        step_into = '',
        step_out = '',
        step_over = '',
        terminate = '',
      },
      help = {
        border = nil,
      },
      -- Controls how to jump when selecting a breakpoint or navigating the stack
      -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
      -- Only a subset of the options is available: newtab, useopen, usetab and uselast
      -- Can also be a function that takes the current winnr and the bufnr that will jumped to
      -- If a function, should return the winnr of the destination window
      switchbuf = 'usetab',
      -- Auto open when a session is started and auto close when all sessions finish
      auto_toggle = true,
      -- Reopen dapview when switching tabs
      follow_tab = true,
    },
    config = function(_, opts)
      require('nvim-dap-virtual-text').setup {} -- optional
      local dap, dapview = require 'dap', require 'dap-view'
      dapview.setup(opts)
      -- UI responsiveness
      -- dap.listeners.before.attach.dapui_config = function()
      --   dapview.open()
      -- end
      -- dap.listeners.before.launch.dapui_config = function()
      --   dapview.open()
      -- end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapview.close(true)
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapview.close(true)
      -- end

      -- Custom breakpoint icons
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '🚫', texthl = 'DapBreakpointCondition', linehl = 'DapBreakpointCondition', numhl = 'DapBreakpointCondition' }
      )
      vim.fn.sign_define('DapStopped', { text = '🚀', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

      -- keymaps
      vim.keymap.set('n', '<leader>du', function()
        -- dapui.toggle { reset = true }
        dapview.toggle(true)
      end, { desc = 'DAP: Toggle UI' })
      vim.keymap.set('n', '<F1>', function()
        -- dapui.toggle { reset = true }
        dapview.toggle(true)
      end, { desc = 'DAP: Toggle UI' })
      vim.keymap.set('n', '<leader>ds', dap.continue, { desc = ' Start/Continue' })
      vim.keymap.set('n', '<F2>', dap.continue, { desc = ' Start/Continue' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step into' })
      vim.keymap.set('n', '<F3>', dap.step_into, { desc = ' Step into' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step over' })
      vim.keymap.set('n', '<F4>', dap.step_over, { desc = ' Step over' })
      vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = ' Step out' })
      vim.keymap.set('n', '<F5>', dap.step_out, { desc = ' Step out' })
      vim.keymap.set('n', '<leader>dq', dap.close, { desc = 'DAP: Close session' })
      vim.keymap.set('n', '<leader>dr', dap.restart_frame, { desc = 'DAP: Restart frame' })
      vim.keymap.set('n', '<F6>', dap.restart, { desc = 'DAP: Start over' })
      -- vim.keymap.set('n', '<F6>', function()
      --   pcall(function() dap.terminate() end)
      --   vim.defer_fn(function()
      --   pcall(function() dap.continue() end)
      --   end, 500)
      -- end, { desc = 'DAP: Start over' })
      vim.keymap.set('n', '<leader>dQ', dap.terminate, { desc = ' Terminate session' })
      vim.keymap.set('n', '<F7>', dap.terminate, { desc = ' Terminate session' })

      vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'DAP: Run to Cursor' })
      vim.keymap.set('n', '<leader>dR', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })
      -- vim.keymap.set('n', '<leader>dh', require('dap.ui.widgets').hover, { desc = 'DAP: Hover' })

      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Breakpoint' })
      vim.keymap.set('n', '<leader>dB', function()
        local input = vim.fn.input 'Condition for breakpoint:'
        dap.set_breakpoint(input)
      end, { desc = 'DAP: Conditional Breakpoint' })
      vim.keymap.set('n', '<leader>dD', dap.clear_breakpoints, { desc = 'DAP: Clear Breakpoints' })

      -- * compile current .cpp file with debug mode
      vim.keymap.set('n', '<leader>dm', '<cmd>!clang++ % -std=c++23 -g -o debug<CR>', { desc = 'DAP: Compile for Debugging' })
      vim.keymap.set('n', '<leader>da', dapview.add_expr, { desc = 'DAP-VIEW: Add to Watch' })
      vim.keymap.set('n', '<leader>dn', dapview.navigate, { desc = 'DAP-VIEW: Switch View' })

      vim.keymap.set('n', ']v', function()
        require('dap-view').navigate { count = vim.v.count1, wrap = true }
      end, { desc = 'DAP-VIEW: Next View' })
      vim.keymap.set('n', '[v', function()
        require('dap-view').navigate { count = -vim.v.count1, wrap = true }
      end, { desc = 'DAP-VIEW: Previous View' })
    end,
  },
}
