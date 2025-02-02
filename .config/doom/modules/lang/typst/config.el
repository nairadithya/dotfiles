;;; lang/typst/config.el -*- lexical-binding: t; -*-

(setq typst-ts-watch-options "--open")

(map! :map 'typst-ts-mode-map :localleader
      :desc "Watch File" :nv "w" #'typst-ts-watch-start
      :desc "Compile File" :nv "c" #'typst-ts-compile
      :desc "Preview File" :nv "v" #'typst-ts-preview)
