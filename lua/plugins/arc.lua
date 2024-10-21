--- --- Check if a file or directory exists in this path
function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
  -- "/" works on both Unix and Windows
  return exists(path .. "/")
end

-- IF arcadia mounted AND we are inside mounted instance - load arc settings
if isdir(os.getenv("HOME") .. "/arcadia/devtools") and vim.fn.getcwd():match("arcadia") then
  ---Whether or not the path is in arc repo
  ---@param path string
  ---@return boolean
  function is_in_arc(path)
    return vim.system({ "arc", "root" }, { cwd = path }):wait().code == 0
  end

  ---Get arc root
  ---@param cwd string? cwd of command
  ---@return string? path the path to arc root
  ---@return boolean ok successfullness
  function get_arc_root(cwd)
    local result
    if not cwd then
      result = vim.system({ "arc", "root" }):wait()
    else
      result = vim.system({ "arc", "root" }, { cwd = cwd }):wait()
    end
    return vim.trim(result.stdout), result.code == 0
  end

  ---Get URL for a file in arcadia
  ---@param path any
  ---@return string?
  function get_url_in_arcadia(path)
    path = path or vim.fn.expand("%")
    if path:sub(1, 1) ~= "/" then
      vim.print(path)
      path = vim.fn.getcwd() .. "/" .. path
    end
    local dir = path:gsub("(.*)/.*", "%1")
    vim.print(dir)
    local root, ok = get_arc_root(dir)
    if not ok then
      vim.print("File is not in arc repo")
      return nil
    end
    local arc_path = path:gsub("^" .. root, "")
    return "https://a.yandex-team.ru/arcadia" .. arc_path
  end

  ---Open file in arcadia
  ---@param line 'range'|'line'?
  ---@param path string?
  function open_in_arcadia(path, line)
    local url = get_url_in_arcadia(path)
    if not url then
      return
    end
    if line then
      if line == "line" then
        url = url .. "#L" .. vim.api.nvim_win_get_cursor(0)[1]
      elseif line == "range" then
        vim.print("normal")
        vim.cmd('execute "normal! \\<ESC>"')
        local start = vim.api.nvim_buf_get_mark(0, "<")[1]
        local endl = vim.api.nvim_buf_get_mark(0, ">")[1]
        if start == endl then
          url = url .. "#L" .. start
        else
          url = url .. "#L" .. start .. "-" .. endl
        end
      end
    end
    vim.ui.open(url)
  end

  ---for mapping
  ---@param mode 'range'|'line'?
  function arcadia_map(mode)
    return function()
      open_in_arcadia(nil, mode)
    end
  end

  vim.keymap.set("n", "<leader>t", function()
    vim.ui.open("https://st.yandex-team.ru/" .. vim.fn.expand("<cfile>"))
  end, { desc = "Open a tracker ticket" })

  vim.keymap.set("n", "<leader>o", arcadia_map(), {
    desc = "Open file in arcadia",
  })

  vim.keymap.set("n", "<leader>O", arcadia_map("line"), {
    desc = "Open file in arcadia",
  })

  vim.keymap.set("v", "<leader>o", arcadia_map("range"), {
    desc = "Open file in arcadia",
  })

  vim.api.nvim_create_user_command("PR", function()
    vim.system({ "arc", "pr", "view" })
  end, {
    desc = "Open a pr in arcadia",
  })

  -- Signify

  return {
    dir = "~/arcadia/devtools/vim/plugin_bundles/signify",
    keys = {
      { "<leader>ga", desc = "Arcadia Signify" },
      { "<leader>gd", "<cmd>SignifyDiff<CR>", desc = "Show signify diff tab" },
      { "<leader>gan", "<cmd>SignifyEnable<CR>", desc = "Set signify oN" },
      { "<leader>gaf", "<cmd>SignifyDisable<CR>", desc = "Set signify ofF" },
    },
    dev = true,
  }
else
  return {}
end
