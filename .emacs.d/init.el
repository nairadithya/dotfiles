;; Custom file setup
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Load External Files
(defun my/load-config (file-name)
  (load (expand-file-name file-name user-emacs-directory)))

(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))

(my/load-config "cache.el")

;; Packages Setup
(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))


(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Mode Settings
(tool-bar-mode 0)
(menu-bar-mode 0)
(global-display-line-numbers-mode 1)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(icomplete-mode 1)

;; MODELINE
(setq mode-line-format " %f %I")
(load-theme 'atlas t)
(set-face-attribute 'default nil :font "CaskaydiaCove Nerd Font" :height 120)

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package evil
  :ensure t)
