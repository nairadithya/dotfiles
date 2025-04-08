;;; ../../dotfiles/.config/doom/org-config.el -*- lexical-binding: t; -*-

(after! org
  (setq org-directory "~/Sync/Org-Garden/")
  ;; org-journal
  (setq org-journal-file-format "%Y_%m_%d.org")
  (setq org-journal-date-format "%A, %d %B %Y")
  (setq org-journal-date-prefix "** ")
  (setq org-journal-time-prefix "*** ")
  (setq org-journal-search-result-date-format "%A, %d %B %Y")


  (setq org-preview-latex-process-alist
        '((dvisvgm :programs ("latex" "dvisvgm")
           :description "dvi > svg"
           :message "you need to install the programs: latex and dvisvgm."
           :use-xcolor t
           :image-input-type "dvi"
           :image-output-type "svg"
           :image-size-adjust (1.7 . 1.5)
           :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
           :image-converter ("dvisvgm %f --no-fonts --exact -o %o"))))

  (after! org (require 'org-xopp) (org-xopp-setup))

  (setq org-latex-compiler "lualatex")
  (setq org-latex-pdf-process
        (list (concat "latexmk -"
                      org-latex-compiler
                      " -recorder -synctex=1 -bibtex-cond %b")))


  (defun cleanup-latex-files (project-plist)
    (let ((source-dir (plist-get project-plist :base-directory)))
      (dolist (ext '("synctex.gz" "tex" "pdf"))
        (let ((files (directory-files source-dir t (concat "\\." ext "$"))))
          (message "found %d %s files to delete: %s"
                   (length files) ext (mapconcat 'identity files ", "))
          (mapc (lambda (file)
                  (when (file-exists-p file)
                    (delete-file file)
                    (message "deleted: %s" file)))
                files)))))

  (setq org-publish-project-alist
        '(("college-notes"
           :base-directory "~/university-notes/college-notes/"
           :publishing-directory "~/university-notes/college-notes/exports"
           :publishing-function org-latex-publish-to-pdf
           :completion-function cleanup-latex-files)))

  (setq org-preview-latex-default-process 'dvisvgm)

  (after! org (plist-put org-format-latex-options :scale 1.00))
  )
