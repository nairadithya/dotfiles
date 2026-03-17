;;; cache.el --- Cache file locations -*- lexical-binding: t; -*-

(require 'url)
(require 'saveplace)
(require 'recentf)
(require 'tramp)
(require 'project)

(defvar my/emacs-cache-dir (expand-file-name "~/.cache/emacs/"))


(dolist (dir '("elpa"
               "transient"
               "auto-save"
               "auto-save-list"
               "backups"
               "locks"
               "eln-cache"))
  (make-directory (expand-file-name dir my/emacs-cache-dir) t))

(unless (file-directory-p my/emacs-cache-dir)
  (make-directory my/emacs-cache-dir t))

;; Native compilation
(startup-redirect-eln-cache
 (expand-file-name "eln-cache/" my/emacs-cache-dir))

;; Auto-save files (#file#)
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" my/emacs-cache-dir) t)))

;; Auto-save session list
(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" my/emacs-cache-dir))

;; Backup files (file~)
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" my/emacs-cache-dir))))

;; URL cache
(setq url-history-file
      (expand-file-name "url/history" my/emacs-cache-dir))

;; Save-place (cursor positions in files)
(setq save-place-file
      (expand-file-name "save-place" my/emacs-cache-dir))

;; Recent files
(setq recentf-save-file
      (expand-file-name "recentf" my/emacs-cache-dir))

;; Tramp
(setq tramp-persistency-file-name
      (expand-file-name "tramp" my/emacs-cache-dir))

(setq package-user-dir
      (expand-file-name "elpa/" my/emacs-cache-dir))

(setq project-list-file
      (expand-file-name "projects" my/emacs-cache-dir))

(provide 'cache)
