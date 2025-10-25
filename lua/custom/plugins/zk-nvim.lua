return {
  'zk-org/zk-nvim',
  config = function()
    require('zk').setup {
      -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
      -- or select" (`vim.ui.select`).
      picker = 'snacks_picker',
      picker_options = {
        -- telescope = require('telescope.themes').get_ivy(),

        -- or if you use snacks picker

        snacks_picker = {
          layout = {
            preset = 'ivy',
          },
        },
      },

      lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
          name = 'zk',
          cmd = { 'zk', 'lsp' },
          filetypes = { 'markdown' },
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
        },
      },
    }

    local opts = { noremap = true, silent = false }

    -- Create a new notebook after asking for its title.
    -- using zk, not zk-nvim
    -- need zk (zk cli) installed
    vim.keymap.set('n', '<leader>znb', function()
      local title = vim.fn.input 'Title: '
      if title ~= '' then
        vim.cmd('!zk init ~/notebooks/' .. title .. ' --no-input')
      end
    end, { desc = 'Create new notebook' })
    -- Create a new note after asking for its title.
    vim.api.nvim_set_keymap(
      'n',
      '<leader>znn',
      "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
      vim.tbl_extend('force', { desc = 'Create new note' }, opts)
    )

    -- Open notes.
    vim.api.nvim_set_keymap('n', '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", vim.tbl_extend('force', { desc = 'Open note' }, opts))
    -- Open notes associated with the selected tags.
    vim.api.nvim_set_keymap('n', '<leader>zt', '<Cmd>ZkTags<CR>', opts)

    -- Search for the notes matching a given query.
    vim.api.nvim_set_keymap(
      'n',
      '<leader>zf',
      "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
      vim.tbl_extend('force', { desc = 'Search notes' }, opts)
    )
    -- Search for the notes matching the current visual selection.
    vim.api.nvim_set_keymap('v', '<leader>zf', ":'<,'>ZkMatch<CR>", vim.tbl_extend('force', { desc = 'Search notes using selected text' }, opts))
  end,
}
