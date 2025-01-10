return {
    {
        "windwp/nvim-autopairs",
        name="Autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end
    }
}
