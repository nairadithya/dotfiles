;; Packages Setup
(require 'use-package)
(require 'package)

(setq package-native-compile t ;; Enabling Native Compilation and ignoring async reports and erros
      native-comp-async-report-warnings-errors nil)
(unless (package-installed-p 'use-package) ;; Guard that Claude told me toadd.
  (package-install 'use-package))
(setq use-package-always-ensure t) ;; Basically ensures every package
(setq package-archives ;; Repo setup
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))

(package-initialize)
;; PACKAGES
(use-package magit
  :defer t
  :bind ("C-x g" . magit-status))

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  )

(use-package vertico
  :ensure t
  :config
  (vertico-mode)
  (setq vertico-count 20
	vertico-resize nil
	vertico-cycle t)
  (define-key minibuffer-local-map (kbd "<escape>") #'abort-recursive-edit)
  )
