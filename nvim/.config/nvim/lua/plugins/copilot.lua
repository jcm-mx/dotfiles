-- ~/.config/nvim/lua/plugins/copilot.lua
return {
  -- Async copilot engine (replaces the official vim plugin)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<Tab>",
          accept_word = "<C-l>",
          accept_line = "<C-j>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false }, -- using cmp integration instead
      filetypes = {
        python = true,
        lua = true,
        c = true,
        cpp = true,
        markdown = true,
        yaml = true,
        toml = true,
        bash = true,
        sh = true,
        ["*"] = false, -- opt-in per filetype rather than opt-out
      },
    },
  },

  -- Copilot source for blink.cmp
  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = { "zbirenbaum/copilot.lua" },
  },

  -- Wire into blink.cmp
  {
    "saghen/blink.cmp",
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    opts = {
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      model = "gpt-4o",
      auto_follow_cursor = true,
      show_help = true,
      window = {
        layout = "vertical", -- chat opens as a vertical split
        width = 0.35, -- 35% of screen width
      },
      mappings = {
        complete = { insert = "<Tab>" },
        close = { normal = "q", insert = "<C-c>" },
        reset = { normal = "<C-r>", insert = "<C-r>" },
        submit_prompt = { normal = "<CR>", insert = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
        show_diff = { normal = "<C-d>" },
      },
    },
    keys = {
      -- Chat
      { "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Copilot chat" },
      { "<leader>cx", "<cmd>CopilotChatClose<cr>", desc = "Close chat" },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "Reset chat" },
      { "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Select model" },

      -- Actions on selection (visual mode)
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain code", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix code", mode = { "n", "v" } },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Generate tests", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs", mode = { "n", "v" } },
      { "<leader>cR", "<cmd>CopilotChatReview<cr>", desc = "Review code", mode = { "n", "v" } },

      -- Quick inline prompt
      {
        "<leader>ci",
        function()
          local input = vim.fn.input("Quick prompt: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
          end
        end,
        desc = "Inline prompt",
        mode = { "n", "v" },
      },
    },
  },
}
