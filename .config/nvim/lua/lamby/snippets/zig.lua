local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep

ls.add_snippets("zig", {
	s("import", {
		t("const "),
		i(1),
		t(" = @import(\""),
        rep(1),
        i(2),
        t("\")"),
        i(3),
        t(";"),
		i(0),
	}),}
)
