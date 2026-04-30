;; -*- lexical-binding: t; -*-

(setq
 website-directory (expand-file-name "~/projects/website/")
 posts-directory "src/content/blog/"
 )

(defun find-blog-post ()
  (interactive)
  (let ((default-directory (concat website-directory posts-directory)))
    (call-interactively #'find-file)))

(setq org-notes-directory (expand-file-name "~/notes/"))

(defun my/find-notes ()
  (interactive)
  (let ((default-directory org-notes-directory))
    (call-interactively #'find-file)))

(provide 'utils)
