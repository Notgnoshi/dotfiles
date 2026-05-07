-- System-clipboard bindings via the `clip` script. By using `clip`, I get x11, wayland, and sshclip support
vim.keymap.set("i", "<C-S-p>", [[<C-r><C-o>=system('clip --paste')<cr>]], { silent = true })
vim.keymap.set("i", "<C-y>", [[<Esc>"cyy:call system('clip --copy', @c)<cr>]], { silent = true })
vim.keymap.set("v", "<C-y>", [["cy:call system('clip --copy', @c)<cr>]], { silent = true })
vim.keymap.set("v", "<C-S-p>", [[:<C-u>let @c=system('clip --paste')<cr>gv"cP]], { silent = true })
vim.keymap.set("n", "<C-S-p>", [[:let @c=system('clip --paste')<cr>"cP]], { silent = true })
vim.keymap.set("n", "<C-y>", [["cyy:call system('clip --copy', @c)<cr>]], { silent = true })
