local function get_python()
  local cwd = vim.fn.getcwd()
  for _, venv in ipairs({ ".venv", "venv", "env" }) do
    local python = cwd .. "/" .. venv .. "/bin/python"
    if vim.fn.executable(python) == 1 then
      return python
    end
  end
  return vim.fn.exepath("python3") or "python"
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Auto-open/close UI with debug sessions
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Bootstrap debugpy from the active venv (or system python)
      require("dap-python").setup(get_python())

      -- pytest is the default test runner for dap-python
      require("dap-python").test_runner = "pytest"
    end,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                              desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,                      desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                                       desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end,                                                      desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end,                                                      desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end,                                                       desc = "Step out" },
      { "<leader>dR", function() require("dap").run_to_cursor() end,                                                  desc = "Run to cursor" },
      { "<leader>dt", function() require("dap").terminate() end,                                                      desc = "Terminate session" },
      { "<leader>du", function() require("dapui").toggle() end,                                                       desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end,                                                         desc = "Evaluate expression",  mode = { "n", "v" } },
      { "<leader>dm", function() require("dap-python").test_method() end,                                             desc = "Debug nearest test method" },
      { "<leader>dM", function() require("dap-python").test_class() end,                                              desc = "Debug nearest test class" },
    },
  },
}
