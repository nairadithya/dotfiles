(use-package c-ts-mode
  :hook
  ;; Enable useful minor modes
  (c-ts-mode . electric-pair-mode)
  (c-ts-mode . electric-indent-mode)
  (c-ts-mode . display-line-numbers-mode)
  (c-ts-mode . hs-minor-mode)          ; code folding

  :custom
  ;; Indentation
  (c-ts-mode-indent-offset 4)          ; 4-space indentation
  (c-ts-mode-indent-style 'k&r)      ; or 'gnu, 'k&r, 'bsd, 'stroustrup

  ;; Use tree-sitter modes automatically
  (major-mode-remap-alist
   '((c-mode . c-ts-mode)
     (c++-mode . c++-ts-mode)
     (c-or-c++-mode . c-or-c++-ts-mode))))
