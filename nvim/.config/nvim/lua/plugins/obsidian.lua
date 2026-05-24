-- ~/.config/nvim/lua/plugins/obsidian.lua
return {

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "qa-kb", path = "~/notes" },
      },

      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        template = "templates/daily.md",
      },

      templates = {
        folder = "templates",
      },

      -- Use telescope for search (already in your stack)
      picker = {
        name = "telescope.nvim",
      },

      completion = {
        nvim_cmp = true,
        min_chars = 2, -- autocomplete [[links]] after 2 chars
      },

      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        },
      },

      -- Keep filenames simple and searchable
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          suffix = tostring(os.time())
        end
        return suffix
      end,
    },

    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's daily note" },
      { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes (grep)" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show links in note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
      { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
      { "<leader>otag", "<cmd>ObsidianTags<cr>", desc = "Browse by tag" },
    },
  },
}
