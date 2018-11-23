(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("melpa2" . "http://www.mirrorservice.org/sites/melpa.org/packages/"))
(add-to-list 'package-archives
	     '("melpa3" . "http://www.mirrorservice.org/sites/stable.melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

;; show line-number
(global-linum-mode t)

(use-package try
	     :ensure t)

(use-package which-key
	     :ensure t
	     :config
	     (which-key-mode))

(use-package org
  :ensure t
  :pin org)

(setenv "BROWSER" "firefox-browser")

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
	 ((agenda "")
	 (alltodo "")))))
(global-set-key (kbd "C-c c") 'org-capture)
(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advice capture-finalize to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))
(defadvice org-capture-destory
    (after delte-capture-frame activate)
  "Advice capture-destroy to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))
(use-package noflet
  :ensure t)
(defun make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")))
  (select-frame-by-name "capture")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
	  (org-capture)))
(define-key org-mode-map (kbd "C-c >") (lambda () (interactive (org-time-stamp-inactive))))
(use-package htmlize
  :ensure t)

;; Ace windows for easy window switching
(use-package ace-window
  :ensure t
  :init
  (progn
    (setq aw-scope 'frame)
    (global-set-key (kbd "C-x O") 'other-frame)
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))))

;; Swiper / Ivy / Counsel
(use-package counsel
  :ensure t
  :bind
  (("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)))
(use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)
	 ("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)))

;; Avy - navigate by searching for a letter on the screen and jumping to it
(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-word-1))

;; Autocomplete
(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)))

;; Company - Modular text completion framework
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (global-company-mode t))
(use-package company-irony
  :ensure t
  :config
  (add-to-list 'company-backends 'company-irony))
(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))
(use-package irony-eldoc
  :ensure t
  :config
  (add-hook 'irony-mode-hook #'irony-eldoc))
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode-hook)
(use-package company-jedi
  :ensure t
  :config(add-hook 'python-mode-hook 'jedi:setup))
(add-hook 'python-mode-hook 'my/python-mode-hook)

;; Flycheck
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;; Python
(setq py-pyton-command "python3")
(setq python-shell-interpreter "python3")
(use-package elpy
  :ensure t
  :config
  (elpy-enable))
(use-package virtualenvwrapper
  :ensure t
  :config
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell))

;; Yasnippet - Yet another snippet extesion for Emacs
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

;; Undo Tree
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

;; Highlights the current cursor line
;(global-hl-line-mode t)

;; flashes the cursor's line when you scroll
(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

;; delete all the whitespace when you hit backspace or delete
(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))

;; multiple cursors
(use-package multiple-cursors
  :ensure t)

;; expand the marked region in semantic increments (negative prefix to reduce region)
(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(setq save-interprogram-paste-before-kill t)

(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "<f6>") 'revert-buffer)

;; git
(use-package magit
  :ensure t
  :init
  (progn
    (bind-key "C-x g" 'magit-status)))
(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode +1))
(use-package git-timemachine
  :ensure t)

;; c++
(use-package ggtags
  :ensure t
  :config
  (add-hook 'c-mode-common-hook
	    (lambda ()
	      (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
		(ggtags-mode 1)))))

;; dumb-jump - jump to definition for multiple languages without configuration
(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
	 ("M-g j" . dump-jump-go)
	 ("M-g x" . dumb-jump-go-prefer-external)
	 ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config
  :init
  (dumb-jump-mode)
  :ensure t)

;; origami - flexible text folding
(use-package origami
  :ensure t)

;; shell-pop - helps you to use shell easily
(use-package shell-pop
  :ensure t
  :bind (("s-t" . shell-pop))
  :config
  (setq shell-pop-shell-type (quote ("eshell" "eshell" (lambda nil (eshell)))))
  (setq shell-pop-term-shell "eshell")
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

;; Wgrep - writable grep buffer and apply the changes to files
(use-package wgrep
  :ensure t)
(use-package wgrep-ag
  :ensure t)
(require 'wgrep-ag)

;; regex
(use-package pcre2el
  :ensure t
  :config
  (pcre-mode))

;; eyebrowse - easy window config switching
(use-package eyebrowse
  :ensure t
  :config
  (eyebrowse-mode))

;; easy-kill - kill and mark things easily
(use-package easy-kill
  :ensure t
  :config
  (global-set-key [remap kill-ring-save] #'easy-kill)
  (global-set-key [remap mark-sexp] #'easy-mark))
