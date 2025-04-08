;; -*- no-byte-compile: t; -*-
;;; lang/typst/packages.el

(package! typst-ts-mode
  :recipe (:type git :host sourcehut :repo "meow_king/typst-ts-mode"
           :files (:defaults "*.sh")))

(when (modulep! :tools tree-sitter)
  (package! tree-sitter-langs))

(package! ox-typst)
