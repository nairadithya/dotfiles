;; Treesitter setup  -*- lexical-binding: t; -*-
(setq treesit-install-language-grammar-directory
      (expand-file-name "tree-sitter/" "~/.cache/emacs/"))
(setq treesit-extra-load-path
      (list treesit-install-language-grammar-directory))
(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (c "https://github.com/tree-sitter/tree-sitter-cpp")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (elisp "https://github.com/Wilfred/tree-sitter-elisp")
        (html "https://github.com/tree-sitter/tree-sitter-html")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (make "https://github.com/alemuller/tree-sitter-make")
        (markdown "https://github.com/ikatyang/tree-sitter-markdown")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")
        (typst "https://github.com/uben0/tree-sitter-typst")
        ))


;; Typst Setup
(require 'typst-ts nil t)
(add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-ts-mode))


(provide 'languages)
