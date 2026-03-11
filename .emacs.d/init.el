; --- init.el --- Emacs configuration -*- lexical-binding: t; -*-
;; GC Optimization 
(setq gc-cons-threshold (* 50 1000 1000))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))))

;; Custom file setup
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Load External Files
(defun load-module (file-name)
  (load (expand-file-name file-name (concat user-emacs-directory "modules/"))))

(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))

(load-module "cache.el")
(load-module "visuals.el")
(load-module "packages.el")
(load-module "keybinds.el")

(use-package emacs
  :custom
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package dired
  :ensure nil
  :config
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
  )
