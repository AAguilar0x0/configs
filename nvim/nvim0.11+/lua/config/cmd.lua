vim.api.nvim_create_user_command('W', function(opts)
  if not opts.bang then
    vim.lsp.buf.format()
  end
  vim.cmd('write' .. (opts.bang and '!' or ''))
end, { bang = true })
