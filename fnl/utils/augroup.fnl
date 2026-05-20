(fn augroup [name]
  (vim.api.nvim_create_augroup (.. :lim/ name) {:clear true}))

{: augroup}
