-- ~/.config/nvim/lua/plugins/oil.lua
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false, -- load immediately so it can hijack netrw
    opts = {
      default_file_explorer = true, -- replaces netrw
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true, -- show dotfiles (relevant for your dotfiles/stow setup)
        natural_order = true,
        sort = {
          { "type", "asc" }, -- directories first
          { "name", "asc" },
        },
      },
      win_options = {
        wrap = false,
        signcolumn = "yes",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 40,
        border = "rounded",
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent", -- go up a directory
        ["_"] = "actions.open_cwd", -- jump to cwd
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      use_default_keymaps = false, -- only use what's above
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer (oil)" },
      {
        "<leader>E",
        function()
          require("oil").toggle_float()
        end,
        desc = "File explorer (float)",
      },
    },
  },
}
