return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Autocompletion
      'hrsh7th/nvim-cmp', -- Required
      'hrsh7th/cmp-nvim-lsp', -- Required
      'hrsh7th/cmp-buffer', -- Optional
      'hrsh7th/cmp-path', -- Optional
      'saadparwaiz1/cmp_luasnip', -- Optional
      'hrsh7th/cmp-nvim-lua', -- Optional

      -- Snippets
      'L3MON4D3/LuaSnip', -- Required
      'rafamadriz/friendly-snippets', -- Optional
    },
    config = function()
      vim.filetype.add({ extension = { templ = 'templ' } })
      -- vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

      -- For snippets configuraiton
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_mappings = {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        -- disable completion with tab
        -- this helps with copilot setup
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
      }
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert(cmp_mappings),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
        },
      })

      vim.diagnostic.config({
        -- virtual_lines = true,
        virtual_lines = {
          current_line = true,
        },
        virtual_text = true,
        severity_sort = true,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local opts = { buffer = bufnr, remap = false }
          -- local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- if client ~= nil and client:supports_method('textDocument/completion') then
          --   vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
          --   vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
          --   vim.keymap.set('i', '<C-Space>', function()
          --     vim.lsp.completion.get()
          --   end)
          -- end

          vim.keymap.set('n', 'gd', function()
            vim.lsp.buf.definition()
          end, opts)
          vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
          vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover()
          end, opts)
          vim.keymap.set('n', '<leader>vws', function()
            vim.lsp.buf.workspace_symbol()
          end, opts)
          vim.keymap.set('n', '<leader>vd', function()
            vim.diagnostic.open_float()
          end, opts)
          vim.keymap.set('n', '[d', function()
            vim.lsp.diagnostic.goto_next()
          end, opts)
          vim.keymap.set('n', ']d', function()
            vim.lsp.diagnostic.goto_prev()
          end, opts)
          vim.keymap.set('n', '<leader>vca', function()
            vim.lsp.buf.code_action()
          end, opts)
          vim.keymap.set('n', '<leader>vrr', function()
            vim.lsp.buf.references()
          end, opts)
          vim.keymap.set('n', '<leader>vrn', function()
            vim.lsp.buf.rename()
          end, opts)
          vim.keymap.set('i', '<C-h>', function()
            vim.lsp.buf.signature_help()
          end, opts)
        end,
      })

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
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --
        html = {
          filetypes = { 'html', 'templ' },
        },

        -- htmx = {
        --   filetypes = { "html", "templ" },
        -- },

        tailwindcss = {
          filetypes = { 'templ', 'astro', 'javascript', 'typescript', 'react' },
          init_options = {
            userLanguages = { templ = 'html' },
          },
        },

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim' } },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        -- 'gopls',
        'ts_ls',
        -- 'rust_analyzer',
        -- 'templ',
        -- 'html',
        -- 'htmx',
        -- 'tailwindcss',
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
