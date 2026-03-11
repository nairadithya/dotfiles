;; Mode Settings
(tool-bar-mode 0)
(menu-bar-mode 0)
(global-display-line-numbers-mode 1)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil)

;; MODELINE
(force-mode-line-update t) 
(setq-default mode-line-format '("%e"
				 mode-line-misc-info
				 mode-line-modes
				 mode-line-front-space
				 mode-line-modified " "
				 mode-line-buffer-identification "  "
				 mode-line-position "  "
				 mode-line-end-spaces))

(load-theme 'atlas t)
(set-face-attribute 'default nil :font "CaskaydiaCove Nerd Font" :height 160)
