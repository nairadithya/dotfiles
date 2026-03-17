;; --- init.el --- Emacs configuration -*- lexical-binding: t; -*-
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
(defun load-module (name)
  (require (intern name)
           (expand-file-name (concat name ".el")
                             (concat user-emacs-directory "modules/"))))

;; Themes Loading
(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))

(load-module "cache")
(load-module "packages")
(load-module "visuals")
(load-module "utils")
(load-module "ocaml")

(use-package emacs
  :custom
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
  (save-place-mode 1) ;; Save the place your cursor was at for files.
  (auto-save-visited-mode 1) ;; Automatically saves buffers, with a timer.
  ;; Settings
  (setq read-file-name-completion-ignore-case t
	read-buffer-completion-ignore-case t
	completion-ignore-case t
	;; Choose newer config over compiled/elisp
	load-prefer-newer t
	backup-by-copying t
	;; Flash frame (see visuals.el for the flash code)
	visible-bell t
	apropos-do-all t
	ediff-window-setup-function 'ediff-setup-windows-plain
	auto-save-visited-interval 30
	auto-save-default nil
	)
  )

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-define-key 'normal 'global (kbd "SPC w") evil-window-map)
  )

(use-package transient 
  :demand t 
  :ensure t)

(use-package magit
  :defer t
  :after transient
  :commands (magit-status) 
  :bind ("C-x g" . #'magit-status)
  :config
  (evil-define-key 'normal 'global (kbd "SPC g") #'magit-status)
  )

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package dired
  :ensure nil
  :config
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  (evil-define-key 'normal 'global (kbd "SPC o -") #'dired-jump)
  (evil-define-key 'normal dired-mode-map (kbd "-") ;; Bind to go up one directory, why not dired-up-directory? find-alternate-file updates the current buffer instead of creating a new one.
    (lambda () (interactive)
      (find-alternate-file "..")))
  )

(use-package compile
  :ensure nil
  :custom
  (compilation-always-kill t)
  (compilation-scroll-output t)
  (ansi-color-for-compilation-mode t))

(use-package project
  :ensure nil
  :config
  (evil-define-key 'normal 'global (kbd "SPC SPC") #'project-find-file)
  (evil-define-key 'normal 'global (kbd "SPC p") project-prefix-map)
  )

(use-package vertico
  :ensure t
  :config
  (vertico-mode)
  (setq vertico-count 20
	vertico-resize nil
	vertico-cycle t)
  (define-key minibuffer-local-map (kbd "<escape>") #'abort-recursive-edit)
  )

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) 

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25
	doom-modeline-bar-width 2
	doom-modeline-icon t
	doom-modeline-buffer-encoding nil 
	doom-modeline-modal-modern-icon t
	doom-modeline-major-mode-icon t
	doom-modeline-buffer-file-name-style 'truncate-upto-project
	doom-line-bar-width 0)
  )
