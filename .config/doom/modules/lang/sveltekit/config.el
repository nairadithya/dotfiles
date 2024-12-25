;;; lang/sveltekit/config.el -*- lexical-binding: t; -*-

(use-package! svelte-mode
  :init
  (when (modulep! +lsp)
    (add-hook 'svelte-mode-hook #`lsp! 'append))
  :config
  ()
