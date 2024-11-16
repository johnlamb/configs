local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("all", {
	s("sh", {
		t("#!/usr/bin/env "),
		i(1, "python3"),
		i(0),
	}),}
)
