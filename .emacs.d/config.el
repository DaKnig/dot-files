(require 'package)
(setq package-enable-at-startup nil)
;(add-to-list 'package-archives
;			 '("melpa" . "https://melpa.org/packages/"))
;


(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
					(not (gnutls-available-p))))
	       (proto (if no-ssl "http" "https")))
      (when no-ssl
	(warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
      ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
      ;(add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
      (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
      (when (< emacs-major-version 24)
	;; For important compatibility libraries like cl-lib
	(add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)

(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
;  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))
;(use-package auto-package-update
;  :config
;  (setq auto-package-update-delete-old-versions t)
;  (setq auto-package-update-hide-results t)
;  (auto-package-update-maybe))

(setq scroll-step 1)

(setq inhibit-startup-screen t)

(setq ring-bell-function 'ignore)

(when (version<= "26.0.50" emacs-version )
      (global-display-line-numbers-mode))

(when (fboundp 'electric-indent-mode)
  (electric-indent-mode -1))

(desktop-save-mode 1)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 2)
  (setq dashboard-items '((recents  . 30)))
;			  (bookmarks . 5)
;			  (projects . 5)
;			  (agenda . 5)
;			  (registers . 5)))
)

(setq c-default-style "linux")
(setq tab-always-indent t)
(setq indent-tabs-mode t)
(setq c-basic-offset 4)
(setq tab-width 4)

(setq org-replace-disputed-keys t);;https://www.gnu.org/software/emacs/manual/html_node/org/Conflicts.html
     ;;this is supposed to move org-mode keys somewhere. doesnt work.
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(setq org-support-shift-select t) ;;Select text with the arrows

(global-unset-key (kbd "C-f"))
(global-unset-key (kbd "C-S-f"))
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
(global-set-key (kbd "C-S-f") 'isearch-backward)
(define-key isearch-mode-map (kbd "C-S-f") 'isearch-repeat-backward)

(global-unset-key (kbd "C-s"))
(global-unset-key (kbd "C-S-s"))
(global-unset-key (kbd "C-o"))

(global-set-key (kbd "C-s") 'save-buffer)

(global-set-key (kbd "C-o") 'find-file)

(defadvice find-file-read-args (around find-file-read-args-always-use-dialog-box act)
      "Simulate invoking menu item as if by the mouse; see `use-dialog-box'."
      (let ((last-nonmenu-event nil))
	ad-do-it))

(global-unset-key (kbd "C-M-f"))
(global-set-key (kbd "C-M-f") 'query-replace-regexp)

(load-theme 'monokai t)

(use-package beacon
  :ensure t
  :config
    (beacon-mode 1))

(use-package avy
  :ensure t
  :bind
  ("C-'" . 'avy-goto-char))

;  (use-package mark-multiple
  ;    :ensure t
  ;    :bind ("C->" . 'mark-next-like-this))
;  (use-package 'multiple-cursors-mode
 ;   :ensure t
;    :bind (("C->" . 'mc/mark-next-like-this) .
 ;          ("C-<" . 'mc/mark-previous-like-this)))
 (require 'multiple-cursors)
 (global-set-key (kbd "C->") 'mc/mark-next-like-this)
 (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)

(global-unset-key (kbd "C-w"))
(global-set-key (kbd "C-w") 'delete-window) ; close window (or "tab")

(global-unset-key (kbd "C-\\" ))
(global-set-key (kbd "C-\\") 'split-window-right)

;other-window
(global-unset-key (kbd "<C-tab>"))
(global-set-key (kbd "<C-tab>") 'next-multiframe-window)
(define-key org-mode-map (kbd "<C-tab>") 'next-multiframe-window)

(global-unset-key (kbd "<C-iso-lefttab>")) ; shift-tab
(global-set-key (kbd "<C-iso-lefttab>") 'previous-multiframe-window)

(global-set-key (kbd "<M-right>") 'next-multiframe-window)
(define-key org-mode-map (kbd "<M-right>") 'next-multiframe-window)

;  (use-package centaur-tabs
;    :demand
;    :config
;    (centaur-tabs-mode t)
;    :bind
;    ("C-<tab>" . centaur-tabs-backward)
;    ("C-S-<tab>" . centaur-tabs-forward))

(defun my-newline ()
  "This gets down a line and keeps indentation. assumes spaces."
  (interactive)
  (let ((x
	 (save-excursion
	   (forward-line 0)
	   (-(-
	      (point)
	      (cdr (cons (back-to-indentation) (point) )))))))
    (newline)
    (insert-char ?\s x)))

(defun my-python-newline ()
  "check char, do shit, then call check-colon on it"
  (interactive)
  (backward-char)
  (let ((x (char-after)))
    (forward-char)
    (my-newline)
    (insert-char ?\s (if (equal x ?:)
	4
	0)
		 )))

(add-hook 'python-mode-hook
	  (lambda ()
	    (local-set-key (kbd "<return>")  'my-python-newline)
	    (setq python-indent 4) ) )
(setq python-shell-interpreter "python3")
;(define-key python-mode-map (kbd "<return>") 'my-newline)
;  (define-key global-map (kbd "<return>") 'my-newline)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (define-key company-active-map (kbd "<tab>") #'company-select-next)
  (define-key company-active-map (kbd "<backtab>") #'company-select-previous)
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  ;same as S-tab
)

(use-package company-irony
  :ensure t
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-irony)
)

(use-package irony 
  :ensure t
  :config
  ;add c and c++ to it
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  ; start the clang server
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

  (add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode)
)

(use-package company-anaconda
  :ensure t
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-anaconda)
  (add-hook 'python-mode-hook 'anaconda-mode)
)

(use-package vhdl-mode
  :ensure t
  :bind
  ("C-/" . 'vhdl-comment-uncomment-region)
)

(define-key company-active-map (kbd "<delete>") 'speedbar-item-delete)
(global-set-key (kbd "C-b") 'speedbar)

(use-package tex-mode
  :ensure t
  :bind
  ("M-C" . 'toggle-input-method)
)
;latex-mode-map
