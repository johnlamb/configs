return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    name = 'LuaSnip',
    config = function()
      require("luasnip").setup({})
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  }
}
