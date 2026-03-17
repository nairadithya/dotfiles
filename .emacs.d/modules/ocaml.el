;; Major mode for editing Dune project files
(use-package dune
  :ensure t)

;; OCaml-specific LSP extensions via Eglot
(use-package ocaml-eglot
  :ensure t
  :hook (tuareg-mode . ocaml-eglot-setup))

(use-package tuareg
  :ensure t
  :hook (tuareg-mode . ocaml-eglot-setup))

(use-package flymake
  :config
  (setq flymake-diagnostic-format-alist
        '((t . (origin code message)))))

(use-package eglot
  :hook (tuareg-mode . eglot-ensure))

(provide 'ocaml)
