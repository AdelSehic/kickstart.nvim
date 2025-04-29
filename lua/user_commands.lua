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
