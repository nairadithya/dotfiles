;; Packages Setup
(require 'package)
(setq package-archives ;; Repo setup
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))
(setq package-install-upgrade-built-in t)
(package-initialize)
;; Options
(setq package-native-compile t ;; Enabling Native Compilation and ignoring async reports and erros
      native-comp-async-report-warnings-errors nil)
(unless (package-installed-p 'use-package) ;; Guard that Claude told me toadd.
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t) ;; Basically ensures every package
