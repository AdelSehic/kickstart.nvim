vim.api.nvim_create_user_command("ExtractJS", function()
  local lines = {}
  local inside_script = false
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:match("<script") then inside_script = true end
    if inside_script then table.insert(lines, line) end
    if line:match("</script>") then inside_script = false end
  end

  -- Open new buffer for extracted JS
  vim.cmd("vsplit")
  vim.cmd("enew")
  vim.bo.filetype = "javascript"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, {})

-- [[ vim.pack helpers ]]
--  See `:help vim.pack`
vim.api.nvim_create_user_command('PackUpdate', function(opts)
  vim.pack.update(#opts.fargs > 0 and opts.fargs or nil)
end, {
  nargs = '*',
  desc = 'Update plugins (all, or the ones given)',
  complete = function()
    return vim.tbl_map(function(p) return p.spec.name end, vim.pack.get(nil, { info = false }))
  end,
})

vim.api.nvim_create_user_command('PackClean', function()
  local inactive = vim
    .iter(vim.pack.get(nil, { info = false }))
    :filter(function(p) return not p.active end)
    :map(function(p) return p.spec.name end)
    :totable()
  if #inactive == 0 then
    vim.notify('No unused plugins to remove', vim.log.levels.INFO)
    return
  end
  local choice = vim.fn.confirm('Remove unused plugins?\n\n' .. table.concat(inactive, '\n'), '&Yes\n&No', 2)
  if choice == 1 then
    vim.pack.del(inactive)
  end
end, { desc = 'Remove plugins that are no longer added in the config' })
