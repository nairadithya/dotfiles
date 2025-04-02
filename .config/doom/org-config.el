;;; ../../dotfiles/.config/doom/org-config.el -*- lexical-binding: t; -*-

(after! org
  (setq org-directory "~/Sync/Org-Garden/")
  ;; org-journal
  (setq org-journal-file-type 'yearly)
  (setq org-journal-file-format "%Y.org")
  (setq org-journal-date-format "%A, %d %B %Y")
  (setq org-journal-date-prefix "** ")
  (setq org-journal-time-prefix "*** ")


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
  (setq org-latex-default-packages-alist
        '(("" "graphicx" t)
          ("" "grffile" t)
          ("" "longtable" nil)
          ("" "wrapfig" nil)
          ("" "rotating" nil)
          ("normalem" "ulem" t)
          ("" "amsmath" t)
          ("" "textcomp" t)
          ("" "amssymb" t)
          ("" "capt-of" nil)
          ("" "hyperref" nil)))
  (setq org-latex-listings t)
  (setq org-latex-classes
        '(("article"
           "\\requirepackage{fix-cm}
\\passoptionstopackage{svgnames}{xcolor}
\\documentclass[11pt]{article}
\\usepackage{fontspec}
\\setmainfont{etbembo}
\\setsansfont[scale=matchlowercase]{inter}
\\setmonofont[scale=matchlowercase]{jetbrainsmono nerd font}
\\usepackage{sectsty}
\\allsectionsfont{\\sffamily}
\\usepackage{enumitem}
\\usepackage[export]{adjustbox}
\\setlist[description]{style=unboxed,font=\\sffamily\\bfseries}
\\usepackage{listings}
\\lstset{frame=single,aboveskip=1em,
	framesep=.5em,backgroundcolor=\\color{aliceblue},
	rulecolor=\\color{lightsteelblue},framerule=1pt}
\\usepackage{xcolor}
\\newcommand\\basicdefault[1]{\\scriptsize\\color{black}\\ttfamily#1}
\\lstset{basicstyle=\\basicdefault{\\spaceskip1em}}
\\lstset{literate=
	    {§}{{\\s}}1
	    {©}{{\\raisebox{.125ex}{\\copyright}\\enspace}}1
	    {«}{{\\guillemotleft}}1
	    {»}{{\\guillemotright}}1
	    {á}{{\\'a}}1
	    {ä}{{\\\"a}}1
	    {é}{{\\'e}}1
	    {í}{{\\'i}}1
	    {ó}{{\\'o}}1
	    {ö}{{\\\"o}}1
	    {ú}{{\\'u}}1
	    {ü}{{\\\"u}}1
	    {ß}{{\\ss}}2
	    {à}{{\\`a}}1
	    {á}{{\\'a}}1
	    {ä}{{\\\"a}}1
	    {é}{{\\'e}}1
	    {í}{{\\'i}}1
	    {ó}{{\\'o}}1
	    {ö}{{\\\"o}}1
	    {ú}{{\\'u}}1
	    {ü}{{\\\"u}}1
	    {¹}{{\\textsuperscript1}}1
            {²}{{\\textsuperscript2}}1
            {³}{{\\textsuperscript3}}1
	    {ı}{{\\i}}1
	    {—}{{---}}1
	    {’}{{'}}1
	    {…}{{\\dots}}1
            {⮠}{{$\\hookleftarrow$}}1
	    {␣}{{\\textvisiblespace}}1,
	    keywordstyle=\\color{darkgreen}\\bfseries,
	    identifierstyle=\\color{darkred},
	    commentstyle=\\color{gray}\\upshape,
	    stringstyle=\\color{darkblue}\\upshape,
	    emphstyle=\\color{chocolate}\\upshape,
	    showstringspaces=false,
	    columns=fullflexible,
	    keepspaces=true}
\\usepackage[a4paper,margin=1in,left=1.5in]{geometry}
\\usepackage{parskip}
\\makeatletter
\\renewcommand{\\maketitle}{%
  \\begingroup\\parindent0pt
  \\sffamily
  \\huge{\\bfseries\\@title}\\par\\bigskip
  \\large{\\bfseries\\@author}\\par\\medskip
  \\normalsize\\@date\\par\\bigskip
  \\endgroup\\@afterindentfalse\\@afterheading}
\\makeatother
[default-packages]
\\hypersetup{linkcolor=blue,urlcolor=darkblue,
  citecolor=darkred,colorlinks=true}
\\atbegindocument{\\renewcommand{\\urlfont}{\\ttfamily}}
[packages]
[extra]"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))

          ("report" "\\documentclass[11pt]{report}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))

          ("book" "\\documentclass[11pt]{book}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))


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
