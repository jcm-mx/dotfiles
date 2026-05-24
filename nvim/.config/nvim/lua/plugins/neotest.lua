return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          runner = "pytest",
          python = ".venv/bin/python", -- adjust if you use a different venv path
        },
      },
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run file tests",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run(vim.fn.expand("%:p:h"))
        end,
        desc = "Run test suite",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle summary",
      },
      { "<leader>ta", "<cmd>NeotestSetArgs<cr>", desc = "Set pytest args" },
      { "<leader>tA", "<cmd>NeotestShowArgs<cr>", desc = "Show pytest args" },
      { "<leader>tx", "<cmd>NeotestClearArgs<cr>", desc = "Clear pytest args" },
    },
  },
}
