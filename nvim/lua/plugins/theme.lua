return {
  {
    "mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,

    config = function()
      vim.g.adwaita_dark = true
      vim.cmd("colorscheme adwaita")
    end,
  },
}
