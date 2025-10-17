return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    -- {
    --   'nvim-telescope/telescope-fzf-native.nvim',
    --   build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    -- },
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({
        -- hidden = true, -- show dotfiles
        -- no_ignore = false, -- still respect .gitignore
        -- no_ignore_parent = false,
        find_command = {
          'rg', -- use ripgrep
          '--files',
          '--hidden',
          '--glob',
          '!.git/*', -- ignore .git directory
        },
      })
    end, {})
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input('Grep > ') })
    end)
    vim.keymap.set('n', '<leader>bs', function()
      builtin.current_buffer_fuzzy_find()
    end)
  end,
}
