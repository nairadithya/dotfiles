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

(use-package ef-themes		  
  :ensure t			
  :init				
  (ef-themes-take-over-modus-themes-mode 1) 
  :config				    
  (setq modus-themes-mixed-fonts t)	    
  (setq modus-themes-italic-constructs t)   
  (modus-themes-load-theme 'ef-frost))    

;; (use-package doom-themes
;;   :ensure t
;;   :custom
;;   ;; Global settings (defaults)
;;   (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
;;   (doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   ;; for treemacs users
;;   :config
;;   (load-theme 'atlas t)

;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)
;;   ;; Enable custom neotree theme (nerd-icons must be installed!)
;;   (doom-themes-neotree-config)
;;   ;; or for treemacs users
;;   (doom-themes-treemacs-config)
;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))


(use-package visual-fill-column
  :after org)

(set-face-attribute 'default nil :font "BlexMono Nerd Font" :height 160)
(set-face-attribute 'fixed-pitch nil :font "BlexMono Nerd Font" :height 160)
(set-face-attribute 'variable-pitch nil :font "IBM Plex Serif" :weight 'regular)
;; MODELINE
(force-mode-line-update t)


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

(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(provide 'visuals)
