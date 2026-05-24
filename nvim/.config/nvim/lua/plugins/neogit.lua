return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      -- Only one of these is needed.
      "sindrets/diffview.nvim", -- optional
      "esmuellert/codediff.nvim", -- optional

      -- For a custom log pager
      "m00qek/baleia.nvim", -- optional

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
      "nvim-mini/mini.pick", -- optional
      "folke/snacks.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enhanced_diff_hl = true, -- better diff highlighting
      view = {
        default = {
          layout = "diff2_horizontal", -- side-by-side
        },
        merge_tool = {
          layout = "diff3_mixed", -- 3-way for conflict resolution
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { width = 35 },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff vs last commit" },
      { "<leader>gfh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
      { "<leader>gfH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
    },
  },
}
