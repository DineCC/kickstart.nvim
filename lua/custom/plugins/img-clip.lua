return {
  'HakonHarnes/img-clip.nvim',
  event = 'VeryLazy',
  opts = {
    default = {
      -- * dir_path setting must be inside 'default' to work
      dir_path = function()
        return vim.fn.expand '%:h' .. '/assets'
      end,
    },

    -- drag and drop options
    drag_and_drop = {
      enabled = true, ---@type boolean | fun(): boolean
      insert_mode = false, ---@type boolean | fun(): boolean
      -- copy the image into the dir_path, then link to the copy
      copy_images = true,
    },
  },
  keys = {
    -- suggested keymap
    { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
  },
}
