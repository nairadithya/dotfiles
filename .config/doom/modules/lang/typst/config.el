;;; lang/typst/config.el --- lexical-binding: t; -*-
;;; Commentary

(setq typst-ts-watch-options "--open")

;; Defining local leader settings
(map! :map 'typst-ts-mode-map :localleader
      :desc "Watch File" :nv "w" #'typst-ts-watch-start
      :desc "Compile File" :nv "c" #'typst-ts-compile
      :desc "Preview File" :nv "v" #'typst-ts-preview)

;; Headings
(map! :map 'typst-ts-mode-map
      :desc "Move Heading Up" "M-k" #'typst-ts-mode-meta-up
      :desc "Move Heading Down" "M-j" #'typst-ts-mode-meta-down
      :desc "Decrease Heading Level" "M-h" #'typst-ts-mode-meta-left
      :desc "Increase Heading Level" "M-l" #'typst-ts-mode-meta-right
      )


(if (modulep! +lsp)
    (with-eval-after-load 'eglot
      (with-eval-after-load 'typst-ts-mode
        (add-to-list 'eglot-server-programs
                     `((typst-ts-mode) .
                       ,(eglot-alternatives `(,typst-ts-lsp-download-path
                                              "tinymist"
                                              "typst-lsp")))))))
