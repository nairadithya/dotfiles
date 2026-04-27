;; Mode Settings  -*- lexical-binding: t; -*-
(tool-bar-mode 0)
(menu-bar-mode 0)
(global-display-line-numbers-mode 1)
(scroll-bar-mode 0)
(global-visual-line-mode -1)
(blink-cursor-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil)

(setf display-line-numbers 'relative)
;; MODELINE
(set-face-attribute 'default nil :font "IosevkaTermSlab Nerd Font" :height 160)
(force-mode-line-update t)
(load-theme 'atlas t)

;; Flash on error with theme colour
(setq visible-bell nil
      ring-bell-function
      (lambda ()
	(let ((orig (face-background 'mode-line))
	      (flash (face-foreground 'font-lock-keyword-face)))
	  (set-face-background 'mode-line flash)
	  (run-with-timer 0.2 nil
			  (lambda ()
			    (set-face-background 'mode-line orig))))))

(provide 'visuals)
