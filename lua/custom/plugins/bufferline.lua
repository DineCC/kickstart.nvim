return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',

  config = function()
    vim.opt.termguicolors = true
    vim.o.mousemoveevent = true
    require('bufferline').setup {
      options = {
        -- * hiding close button won't work
        -- show_buffer_close_icon = true,
        -- show_close_icon = true,
        buffer_close_icon = '⛒',
        hover = {
          enabled = true,
          delay = 0,
          reveal = { 'close' },
        },
      },
      highlights = {
        -- buffer_selected = { bg = '#15161e' },
        fill = { bg = '#1a1b26' },
      },
    }
  end,
}
