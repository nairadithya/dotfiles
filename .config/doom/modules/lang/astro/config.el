;;; lang/astro/init.el -*- lexical-binding: t; -*-

;; WEB MODE
(use-package web-mode :ensure t)

;; ASTRO
(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
              auto-mode-alist))



;; EGLOT
(when (modulep! +lsp)
  (use-package eglot
    :ensure t
    :config
    (add-to-list 'eglot-server-programs
                 '(astro-mode . ("astro-ls" "--stdio"
                                 :initializationOptions
                                 (:typescript (:tsdk "./node_modules/typescript/lib")))))
    :init
    (add-hook 'astro-mode-hook 'eglot-ensure)))
