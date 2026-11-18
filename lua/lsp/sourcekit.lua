-- sourcekit-lsp 随 Xcode toolchain 提供（/usr/bin/sourcekit-lsp），mason 里没有对应 package。
-- lua/plugins/lsp.lua 收集本目录的配置，登记后 LazyVim 才会把它加进启用列表；
-- cmd、filetypes、root_dir（优先认 buildServer.json）由 nvim-lspconfig 提供，无需重复配置。
return {}
