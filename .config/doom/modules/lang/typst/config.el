;;; lang/typst/config.el -*- lexical-binding: t; -*-
;;; Commentary

(setq typst-ts-watch-options "--open")

(map! :map typst-ts-mode-map
      :localleader
      :desc "Watch File" :nv "w" #'typst-ts-watch-start
      :desc "Compile File" :nv "c" #'typst-ts-compile
      :desc "Preview File" :nv "v" #'typst-ts-preview)

(map! :map typst-ts-mode-map
      :desc "Move Heading Up" "M-k" #'typst-ts-mode-meta-up
      :desc "Move Heading Down" "M-j" #'typst-ts-mode-meta-down
      :desc "Decrease Heading Level" "M-h" #'typst-ts-mode-meta-left
      :desc "Increase Heading Level" "M-l" #'typst-ts-mode-meta-right)

(with-eval-after-load 'eglot
  (with-eval-after-load 'typst-ts-mode
    (add-to-list 'eglot-server-programs
                 `((typst-ts-mode) .
                   ,(eglot-alternatives `(,typst-ts-lsp-download-path
                                          "tinymist"
                                          "typst-lsp"))))))


(defun install-typst-tree-sitter-grammar ()
  "Install the Typst tree-sitter grammar if missing."
  (interactive)
  (message "Installing Typst tree-sitter grammar...")
  (when (require 'treesit nil t)
    (ignore-errors
      (treesit-install-language-grammar 'typst))))

(add-hook! 'typst-ts-mode-hook
  (unless (treesit-language-available-p 'typst)
    (message "Typst tree-sitter grammar not found. Run M-x install-typst-tree-sitter-grammar to install it.")))

(after! org
  (require 'ox-typst)
  (add-to-list 'org-export-backends 'typst))
