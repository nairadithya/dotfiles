;;; doom-atlas-theme.el --- A minimal orange-on-dark theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;;; Commentary:
;;
;; A minimal monochromatic Doom Emacs theme.
;; One accent color (orange) on a near-black background.
;;
;; Palette:
;;   bg         #121212  — near-black background
;;   bg-muted   #404040  — raised surfaces, selections
;;   bg-muted+  #737373  — borders, comments, secondary text
;;   fg         #ffffff  — primary text
;;   accent     #ff6507  — orange, used sparingly for keywords/structure
;;
;; Installation:
;;   Place this file in ~/.doom.d/themes/ (or wherever $DOOMDIR/themes/ points).
;;   Then add to ~/.doom.d/config.el:
;;     (setq doom-theme 'doom-atlas)
;;
;;; Code:

(require 'doom-themes)

;;
;;; Variables

(defgroup doom-atlas-theme nil
  "Options for the `doom-atlas' theme."
  :group 'doom-themes)

(defcustom doom-atlas-brighter-comments nil
  "If non-nil, comments will be slightly brighter."
  :group 'doom-atlas-theme
  :type 'boolean)

(defcustom doom-atlas-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-atlas-theme
  :type '(choice integer boolean))

;;
;;; Theme definition

(def-doom-theme doom-atlas
    "A minimal dark theme with a single orange accent."

  ;; name        default     256        16
  ((bg           '("#121212" "black"    "black"      ))
   (fg           '("#ffffff" "#dfdfdf"  "brightwhite"))

   (bg-alt       '("#1c1c1c" "black"    "black"      ))
   (fg-alt       '("#737373" "#6b6b6b"  "white"      ))

   ;; Base scale derived from the muted ramp
   (base0        '("#0a0a0a" "black"    "black"      ))
   (base1        '("#121212" "#121212"  "brightblack"))
   (base2        '("#1e1e1e" "#1e1e1e"  "brightblack"))
   (base3        '("#2a2a2a" "#2a2a2a"  "brightblack"))
   (base4        '("#404040" "#404040"  "brightblack"))
   (base5        '("#555555" "#555555"  "brightblack"))
   (base6        '("#737373" "#737373"  "brightblack"))
   (base7        '("#999999" "#999999"  "brightblack"))
   (base8        '("#c0c0c0" "#c0c0c0"  "white"      ))

   (grey         base6)

   ;; The one accent orange
   (orange       '("#ff6507" "#ff6600"  "brightred"  ))
   (orange-dim   '("#c44d05" "#cc4400"  "red"        ))
   (orange-bg    '("#2a1500" "#1e0e00"  "red"        ))

   ;; Semantic color aliases — all mapped to monochrome ramp or orange
   (red          orange)
   (green        base8)
   (yellow       orange)
   (blue         fg)
   (dark-blue    base4)
   (magenta      base7)
   (violet       base8)
   (cyan         base7)
   (dark-cyan    base4)
   (teal         base7)

   ;; Universal syntax roles
   (highlight      orange)
   (vertical-bar   base4)
   (selection      orange-bg)
   (builtin        base7)
   (comments       (if doom-atlas-brighter-comments base6 base5))
   (doc-comments   base6)
   (constants      orange)
   (functions      fg)
   (keywords       orange)
   (methods        base8)
   (operators      base6)
   (type           base8)
   (strings        base7)
   (variables      fg)
   (numbers        orange-dim)
   (region         orange-bg)
   (error          orange)
   (warning        orange-dim)
   (success        base8)
   (vc-modified    orange-dim)
   (vc-added       base8)
   (vc-deleted     orange)

   ;; Modeline
   (modeline-fg              fg)
   (modeline-fg-alt          base6)
   (modeline-bg              base3)
   (modeline-bg-alt          base2)
   (modeline-bg-inactive     base2)
   (modeline-bg-inactive-alt base1)

   (-modeline-pad
    (when doom-atlas-padded-modeline
      (if (integerp doom-atlas-padded-modeline) doom-charcoal-padded-modeline 4))))

  ;;;; Face overrides
  (((line-number &override)              :foreground base5)
   ((line-number-current-line &override) :foreground base7)
   ((font-lock-comment-face &override)   :slant 'italic)

   ;;;; Mode-line
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground orange)

   ;;;; hl-line
   (hl-line :background base2)

   ;;;; doom-modeline
   (doom-modeline-bar                 :background orange)
   (doom-modeline-buffer-file         :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path         :foreground base7 :weight 'bold)
   (doom-modeline-buffer-project-root :foreground orange :weight 'bold)
   (doom-modeline-buffer-modified     :foreground orange :weight 'bold)

   ;;;; solaire-mode
   (solaire-default-face     :inherit 'default :background bg-alt)
   (solaire-fringe-face      :inherit 'solaire-default-face)
   (solaire-hl-line-face     :background base3)
   (solaire-line-number-face :inherit 'solaire-default-face :foreground base5)
   (solaire-org-hide-face    :background bg-alt :foreground bg-alt)
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt)))

   ;;;; ivy
   (ivy-current-match           :background orange-bg :foreground fg :weight 'bold)
   (ivy-minibuffer-match-face-1 :foreground base6)
   (ivy-minibuffer-match-face-2 :foreground orange :weight 'bold)
   (ivy-minibuffer-match-face-3 :foreground orange-dim)
   (ivy-minibuffer-match-face-4 :foreground base7)

   ;;;; vertico
   (vertico-current :background orange-bg :foreground fg :weight 'bold)

   ;;;; company
   (company-tooltip            :background base2 :foreground fg)
   (company-tooltip-selection  :background orange-bg :foreground fg)
   (company-tooltip-annotation :foreground base6)
   (company-tooltip-common     :foreground orange :weight 'bold)
   (company-scrollbar-bg       :background base3)
   (company-scrollbar-fg       :background base5)

   ;;;; org-mode
   (org-hide             :foreground bg :background bg)
   (org-level-1          :foreground orange     :weight 'bold :height 1.3)
   (org-level-2          :foreground base8      :weight 'bold :height 1.2)
   (org-level-3          :foreground base7      :weight 'bold :height 1.1)
   (org-level-4          :foreground orange-dim :weight 'bold)
   (org-level-5          :foreground base6      :weight 'bold)
   (org-level-6          :foreground base7      :weight 'bold)
   (org-level-7          :foreground base6      :weight 'bold)
   (org-level-8          :foreground base5      :weight 'bold)
   (org-todo             :foreground orange     :weight 'bold)
   (org-done             :foreground base6      :weight 'bold :strike-through t)
   (org-priority         :foreground orange-dim)
   (org-checkbox         :foreground orange)
   (org-tag              :foreground base5      :weight 'normal)
   (org-date             :foreground base7      :underline t)
   (org-link             :foreground orange     :underline t)
   (org-code             :foreground base8      :background base2)
   (org-verbatim         :foreground base7      :background base2)
   (org-block            :background base1      :extend t)
   (org-block-begin-line :foreground base5      :background base1 :extend t)
   (org-block-end-line   :inherit 'org-block-begin-line)

   ;;;; markdown-mode
   (markdown-markup-face           :foreground base5)
   (markdown-header-face           :inherit 'bold :foreground orange)
   (markdown-link-face             :foreground orange)
   (markdown-url-face              :foreground base6 :underline t)
   ((markdown-code-face &override) :background base2)

   ;;;; magit
   (magit-branch-local                :foreground orange)
   (magit-branch-remote               :foreground base8)
   (magit-diff-hunk-heading           :background base3 :foreground base7)
   (magit-diff-hunk-heading-highlight :background base4 :foreground fg)
   (magit-diff-added                  :foreground base8      :background base2)
   (magit-diff-removed                :foreground orange-dim :background base2)
   (magit-diff-added-highlight        :foreground fg         :background base3)
   (magit-diff-removed-highlight      :foreground orange     :background base3)

   ;;;; treemacs
   (treemacs-root-face          :foreground orange :weight 'bold :height 1.2)
   (treemacs-directory-face     :foreground fg)
   (treemacs-file-face          :foreground base8)
   (treemacs-git-modified-face  :foreground orange-dim)
   (treemacs-git-added-face     :foreground base8)
   (treemacs-git-conflict-face  :foreground orange)
   (treemacs-git-untracked-face :foreground base6)

   ;;;; web-mode / CSS
   (web-mode-html-tag-face        :foreground orange)
   (web-mode-html-attr-name-face  :foreground base7)
   (web-mode-html-attr-value-face :foreground base8)
   (css-selector             :foreground orange)
   (css-property             :foreground base8)
   (css-proprietary-property :foreground orange-dim)

   ;;;; LSP / flycheck
   (lsp-ui-doc-background :background base2)
   (flycheck-error        :underline '(:style wave :color "#ff6507"))
   (flycheck-warning      :underline '(:style wave :color "#c44d05"))
   (flycheck-info         :underline '(:style wave :color "#737373")))

  ;;;; Variable overrides
  ())

;;; doom-atlas-theme.el ends here
