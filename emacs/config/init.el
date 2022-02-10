;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(add-to-list 'load-path "~/.emacs.d/ELs")
(load "ligature.el")

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)


(global-set-key (kbd "C-x g") 'webjump)

;; Add Urban Dictionary to webjump
(eval-after-load "webjump"
'(add-to-list 'webjump-sites
              '("Urban Dictionary" .
                [simple-query
                 "www.urbandictionary.com"
                 "http://www.urbandictionary.com/define.php?term="
                 ""])))



;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))



;; full screen magit-status

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

;(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)
;;;broken for some reason rn so disabling

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

;(define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)
;;;broken too

(defun comint-delchar-or-eof-or-kill-buffer (arg)
  (interactive "p")
  (if (null (get-buffer-process (current-buffer)))
      (kill-buffer)
    (comint-delchar-or-maybe-eof arg)))

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map
              (kbd "C-d") 'comint-delchar-or-eof-or-kill-buffer)))

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)



(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (move-to-column col)))

(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

(global-set-key (kbd "M-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))


;;(require 'package)
;;(add-to-list 'package-archives
;;           '("melpa" . "http://melpa.org/packages/") t)
;;
;;(require 'dired-x)
;;
;; allow dired to delete or copy dir
;;(setq dired-recursive-copies (quote always)) ; “always” means no asking
;;(setq dired-recursive-deletes (quote top)) ; “top” means ask once
;;
;;(setq dired-dwim-target t)
;;
(add-to-list 'load-path "~/.emacs.d/lisp/")






(add-to-list 'load-path "~/.emacs.d/site-lisp/use-package")
(require 'use-package)

(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
               "~/.emacs.d/site-lisp/use-package/"))


(setq font-lock-maximum-decoration t)

;;(setq package-archives '(("melpa" . "http://melpa.org/packages/")
;;                         ("gnu" . "http://elpa.gnu.org/packages/")))

;(package-initialize)
;(package-refresh-contents)

(load-theme 'srcery)

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))



(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(astyle clang-format format-all eglot csharp-mode magit yasnippet rustic lsp-ui flycheck company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;(use-package elcord)
;(require 'elcord)
(elcord-mode)

;(add-to-list 'load-path "~/.emacs.d/ergoemacs-mode")
;(require 'ergoemacs-mode)
;(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
;(setq ergoemacs-keyboard-layout "us") ;; Assumes QWERTY keyboard layout
;(ergoemacs-mode 1)

(setq show-paren-delay 0)
(show-paren-mode 1)
(setq electric-pair-mode 1)

;;(global-set-key (kbd "C-z") 'undo)
;;(cua-mode t) ;; Common User Access mode - sets up standard keyboard shortcuts as defined by IBM

;; C# stuff
(use-package tree-sitter :ensure t)
(use-package tree-sitter-langs :ensure t)
;;;(use-package tree-sitter-indent :ensure t)

(use-package csharp-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode)))

(defun my-csharp-mode-hook ()
  (eglot-ensure t)
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook))

(global-ligature-mode t)
;; Enable the www ligature in every possible major mode
(ligature-set-ligatures 't '("www"))

;;; Enable ligatures in programming modes
(ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))

;;;(global-ligature-mode 't)

;;; native-compile all Elisp files under a directory
;    (native-compile-async "/path/to/packages" 'recursively)


;;Replace the default Emacs help keybindings with helpful's (https://github.com/Wilfred/helpful)
;; Note that the built-in `describe-function' includes both functions and macros. `helpful-function' is functions only, so we provide `helpful-callable' as a drop-in replacement.
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)


;;additional keybindings to get the most out of helpful

;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-c C-d") #'helpful-at-point)

;; Look up *F*unctions (excludes macros).
;;
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)

;; Look up *C*ommands.
;;
;; By default, C-h C is bound to describe `describe-coding-system'. I
;; don't find this very useful, but it's frequently useful to only
;; look at interactive functions.
(global-set-key (kbd "C-h C") #'helpful-command)


;;TODO
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


;;Don't warn for following symlinked files
(setq vc-follow-symlinks t)



;;Enable line numbers and customize their format.
(column-number-mode)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;;enables emojis in buffers??
(use-package emojify
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)


;;surface desktop notifications from package code."
(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'notifications))


;Highlight Matching Braces
(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))


;;Tabs over spaces :)
  (setq-default indent-tabs-mode t)


;;prettify dired, I think
(use-package all-the-icons-dired)

(use-package dired
  :ensure nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-hide-details-hide-symlink-targets nil
        delete-by-moving-to-trash t)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))

  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              (dired-omit-mode 1)
              (dired-hide-details-mode 1)
              (unless (or dw/is-termux
                          (s-equals? "/gnu/store/" (expand-file-name default-directory)))
                (all-the-icons-dired-mode 1))
              (hl-line-mode 1)))

  (use-package dired-rainbow
    :defer 2
    :config
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

  (use-package dired-single
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)
)



;(use-package org-appear
;  :hook (org-mode . org-appear-mode))



(use-package magit-todos
  :defer t)

(defalias 'yes-or-no-p 'y-or-n-p);; reduce the annoyance factor
