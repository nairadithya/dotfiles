;; --- init.el --- Emacs configuration -*- lexical-binding: t; -*-
;; GC Optimization 
(setq gc-cons-threshold (* 50 1000 1000))

;; Custom file setup
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Load External Files
;; NOTE: Any file in modules/ needs to `(provide 'module)` at the end.
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
(load-module "meow-config")

(use-package meow :ensure t
  :config
  (meow-setup)
  (meow-global-mode 1)
  )

;; use-package with package.el:
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-show-shortcuts nil)
  )

(use-package emacs
  :custom
  (enable-recursive-minibuffers t)
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
  (save-place-mode 1) ;; Save the place your cursor was at for files.
  (auto-save-visited-mode 1) ;; Automatically saves buffers, with a timer.
  (initial-buffer-choice 'dashboard-open)
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

(use-package ef-themes
  :ensure t
  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  (ef-themes-take-over-modus-themes-mode 1)
  :config
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-autumn))

(use-package transient 
  :demand t 
  :ensure t
  :config
  )

(use-package magit
  :defer t
  :after transient
  :commands (magit-status) 
  :bind ("C-x g" . #'magit-status)
  )

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package dired
  :ensure nil
  :config
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
    (lambda () (interactive)
      (find-alternate-file "..")))


(use-package compile
  :ensure nil
  :custom
  (compilation-always-kill t)
  (compilation-scroll-output t)
  (ansi-color-for-compilation-mode t))

(use-package project
  :ensure nil
 )

;; MINAD Stack
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

(use-package marginalia :ensure t :init (marginalia-mode))

(use-package consult
  :ensure t
  :bind (("C-x b"   . consult-buffer)
         ("C-x C-r" . consult-recent-file)
         ("M-y"     . consult-yank-pop)      ; replaces default yank-pop
         ("M-s g"   . consult-grep)
         ("M-s l"   . consult-line)
         ("M-g i"   . consult-imenu)))

(use-package embark :ensure t)

(use-package consult-eglot
  :ensure t
  :bind (:map eglot-mode-map
              ("M-g s" . consult-eglot-symbols)))

(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :init
  (global-corfu-mode))

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
