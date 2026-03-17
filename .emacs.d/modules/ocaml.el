(use-package neocaml
  :ensure t)

;; Major mode for editing Dune project files
(use-package dune
  :ensure t)

;; OCaml-specific LSP extensions via Eglot
(use-package ocaml-eglot
  :ensure t
  :hook (neocaml-mode . ocaml-eglot-setup))
