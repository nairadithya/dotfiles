;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "IosevkaTermSlab Nerd Font" :size 20 :weight 'regular))
(setq doom-variable-pitch-font (font-spec :family "Charter" :size 24 :weight 'regular))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-sourcerer)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
                                        ;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

(setq calendar-week-start-day 1)

;; Org-latex-preview remove blurriness
;; Org-latex-preview scale adjustment

;; map the TAB to activate the cdlatex tab
;; with this all cdlatex functions work
(map! :map LaTeX-mode-map
      "TAB" #'cdlatex-tab)

(setq +latex-viewers '(sioyek))


(setq! +snippets-dir "~/dotfiles/.config/doom/snippets/")

;; Added support for ruff for apheleia
;; Replace default (black) to use ruff for sorting import and formatting.
(after! apheleia
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  )

;; Opacity
(add-to-list 'default-frame-alist '(alpha-background . 80))

;; Customizing writeroom mode
(after! writeroom-mode
  (setq +zen-text-scale 1.0
        writeroom-mode-line t
        writeroom-width 80
        )
  )


(map! :leader :nv "o c" 'calc)


(load! "org-config")

(use-package! gptel
  :config
  (setq! gptel-model 'claude-sonnet-4.5
         gptel-backend (gptel-make-gh-copilot "Copilot")
         gptel-default-mode 'org-mode)
  )

(map! :leader
      :n "o g" #'gptel
      :v "o g" #'gptel-rewrite)

;; DOOM DASHBOARD STUFF
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "Riced with <3 by Adithya Nair")))

(defun doom-dashboard-widget-footer ()
  (insert
   "\n"
   (+doom-dashboard--center
    (- +doom-dashboard--width 4)
    (with-temp-buffer
      (insert-text-button (or (nerd-icons-mdicon "nf-md-clipboard_list_outline" :face 'doom-dashboard-footer-icon :height 1.3 :v-adjust -0.15)
                              (propertize "org-agenda" 'face 'doom-dashboard-footer))
                          'action (lambda (_) (org-agenda))
                          'follow-link t
                          'help-echo "Check agenda")
      (insert "   ") 
      (insert-text-button (or (nerd-icons-faicon "nf-fa-calculator" :face 'doom-dashboard-footer-icon :height 1.3 :v-adjust -0.15)
                              (propertize "calc" 'face 'doom-dashboard-footer))
                          'action (lambda (_) (calc))
                          'follow-link t
                          'help-echo "Open Calculator")
      (insert "   ") 
      (insert-text-button (or (nerd-icons-mdicon "nf-md-text_box_search" :face 'doom-dashboard-footer-icon :height 1.3 :v-adjust -0.15)
                              (propertize "note-search" 'face 'doom-dashboard-footer))
                          'action (lambda (_) (call-interactively '+default/org-notes-search))
                          'follow-link t
                          'help-echo "Search In Notes")
      (buffer-string)))
   "\n"))


(defun my/current-date-formatted ()
  "Used in a yasnippet to quickly insert my blog frontmatter boilerplate."
  (setq value (calendar-current-date))
  (format "%04d-%02d-%02d"
          (nth 2 value)  ; year
          (nth 0 value)  ; month
          (nth 1 value))) ; day

(setq projectile-project-search-path (list (expand-file-name "~/Projects/")))

(defun projectile-gc-projects ()
  "Remove non-existent directories from `projectile-known-projects'."
  (interactive)
  (let ((old-projects projectile-known-projects))
    (setq projectile-known-projects
          (--select (file-exists-p it) old-projects))
    (unless (= (length old-projects) (length projectile-known-projects))
      (message "Projectile: Cleaned up %d non-existent project(s)."
               (- (length old-projects) (length projectile-known-projects))))))

(setq vterm-shell "/usr/bin/fish")
