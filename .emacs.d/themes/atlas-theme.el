;;; Commentary: Something about the greatest systems programming club
;;; atlas-theme.el --- Minimal orange-on-dark theme -*- lexical-binding: t; -*-

;;; Code:
(deftheme atlas
  "Minimal monochrome dark theme with an orange accent.")

(let* ((bg "#121212")
       (fg "#ffffff")

       (bg-alt "#1c1c1c")
       (fg-alt "#737373")

       (base0 "#0a0a0a")
       (base1 "#121212")
       (base2 "#1e1e1e")
       (base3 "#2a2a2a")
       (base4 "#404040")
       (base5 "#555555")
       (base6 "#737373")
       (base7 "#999999")
       (base8 "#c0c0c0")

       (orange "#ff6507")
       (orange-dim "#c44d05")
       (orange-bg "#2a1500"))

  (custom-theme-set-faces
   'atlas

   ;; core UI
   `(default ((t (:background ,bg :foreground ,fg))))
   `(cursor ((t (:background ,orange))))
   `(fringe ((t (:background ,bg))))
   `(region ((t (:background ,orange-bg))))
   `(highlight ((t (:background ,base3))))
   `(hl-line ((t (:background ,base2))))

   `(vertical-border ((t (:foreground ,base3))))
   `(window-divider ((t (:foreground ,base3))))
   `(window-divider-first-pixel ((t (:foreground ,base3))))
   `(window-divider-last-pixel ((t (:foreground ,base3))))
   ;; line numbers
   `(line-number ((t (:foreground ,base5 :background ,bg))))
   `(line-number-current-line ((t (:foreground ,base7 :background ,bg))))

   ;; modeline
   `(mode-line
     ((t (:background ,base3 :foreground ,fg :box nil))))
   `(mode-line-inactive
     ((t (:background ,base2 :foreground ,base6 :box nil))))

   ;; font lock
   `(font-lock-builtin-face ((t (:foreground ,base7))))
   `(font-lock-comment-face ((t (:foreground ,base5 :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,base5))))
   `(font-lock-constant-face ((t (:foreground ,orange))))
   `(font-lock-function-name-face ((t (:foreground ,fg))))
   `(font-lock-keyword-face ((t (:foreground ,orange :weight bold))))
   `(font-lock-string-face ((t (:foreground ,base7))))
   `(font-lock-type-face ((t (:foreground ,base8))))
   `(font-lock-variable-name-face ((t (:foreground ,fg))))
   `(font-lock-warning-face ((t (:foreground ,orange-dim :weight bold))))

   ;; minibuffer / completion
   `(minibuffer-prompt ((t (:foreground ,orange :weight bold))))

   ;; org-mode
   `(org-level-1 ((t (:foreground ,orange :weight bold :height 1.3))))
   `(org-level-2 ((t (:foreground ,base8 :weight bold :height 1.2))))
   `(org-level-3 ((t (:foreground ,base7 :weight bold :height 1.1))))
   `(org-level-4 ((t (:foreground ,orange-dim :weight bold))))
   `(org-block ((t (:background ,base1))))
   `(org-code ((t (:foreground ,base8 :background ,base2))))
   `(org-verbatim ((t (:foreground ,base7 :background ,base2))))
   `(org-link ((t (:foreground ,orange :underline t))))
   `(org-todo ((t (:foreground ,orange :weight bold))))
   `(org-done ((t (:foreground ,base6 :strike-through t))))

   `(fringe ((t (:background ,bg :foreground ,bg))))
   `(fill-column-indicator ((t (:foreground ,base3))))
   ;; diff / vc
   `(diff-added ((t (:foreground ,base8 :background ,base2))))
   `(diff-removed ((t (:foreground ,orange-dim :background ,base2))))
   `(diff-context ((t (:foreground ,base6))))
   ;; dired
   `(dired-directory ((t (:foreground ,orange :weight bold))))
   `(dired-symlink ((t (:foreground ,base7 :slant italic))))
   `(dired-broken-symlink ((t (:foreground ,orange-dim :strike-through t))))

   ;; errors
   `(error ((t (:foreground ,orange))))
   `(warning ((t (:foreground ,orange-dim))))
   `(success ((t (:foreground ,base8))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-directory load-file-name)))

(setq-default indicate-buffer-boundaries nil
              indicate-empty-lines nil)

(provide-theme 'atlas)

;;; atlas-theme.el ends here
