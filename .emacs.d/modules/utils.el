;; -*- lexical-binding: t; -*-

(setq
 website-directory (expand-file-name "~/projects/website/")
 posts-directory "src/content/blog/"
 )

(defun find-blog-post ()
  (interactive)
  (let ((default-directory (concat website-directory posts-directory)))
    (call-interactively #'find-file)))
