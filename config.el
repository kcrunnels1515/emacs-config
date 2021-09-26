(setq eaf-enable 1)

(setq make-backup-files nil)

(setq visible-bell nil)
(defun ring-bell-function ()
    (message "%s" (propertize "Ding!" 'face '(:foreground "red")))
    )

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/site-lisp/elpa-mirror")
(require 'elpa-mirror)

;; myelpa is the ONLY repository now, dont forget trailing slash in the directory
(setq package-archives '(("myelpa" . "~/.emacs.d/myelpa/")))

;; Using garbage magic hack.
 (use-package gcmh
   :config
   (gcmh-mode 1))
;; Setting garbage collection threshold
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; Silence compiler warnings as they can be pretty disruptive (setq comp-async-report-warnings-errors nil)

;; Silence compiler warnings as they can be pretty disruptive
(if (boundp 'comp-deferred-compilation)
    (setq comp-deferred-compilation nil)
    (setq native-comp-deferred-compilation nil))
;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

(delete-selection-mode t)

(use-package general
 :config
 (general-evil-setup t))
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-x b") 'counsel-ibuffer)
(global-set-key (kbd "C-x a q") 'evil-delete-buffer)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)
(global-set-key (kbd "C-x a a") 'append-to-buffer)


(defun run-compiler-on-line ()
  (interactive)
  (save-buffer)
  (shell-command-on-region (line-beginning-position)
                           (line-end-position)
                           (format "compiler %s" buffer-file-name)))
(defun pkg-update ()
(interactive)
  (package-refresh-contents)
  (cd "/home/kellyr/.emacs.d/site-lisp/emacs-application-framework")
  (shell-command "git pull")
)

(defun other-buff-to-split ()
  (interactive)
  (ivy-read "Switch to buffer: " (counsel-ibuffer--get-buffers)
            :history 'counsel-ibuffer-history
            :action #'other-buff-to-split-1))

(defun other-buff-to-split-1 (x)
  (evil-window-vsplit)
  (evil-buffer (cdr x)))

(nvmap :prefix "SPC"
"r p" 'pkg-update
"r c" '((lambda () (interactive) (load-file "~/.emacs.d/init.el")) :which-key "Reload emacs config")
"e c" 'run-compiler-on-line
"e l" 'other-buff-to-split
"e o" 'org-latex-export-to-pdf
"f q" 'delete-frame
"f n" 'make-frame
"m s" 'emms-start
"m e" 'emms-stop
"m n" 'emms-next
"m b" 'emms-previous
"m ?" 'emms-shuffle
"m p" 'emms-pause
)
(nvmap :prefix "Z"
"X" 'evil-write
"g" 'count-words
)

(use-package evil
:init
(setq evil-want-integration t)
(setq evil-want-keybinding nil)
(setq evil-vsplit-window-right t)
(setq evil-split-window-below t)
(evil-mode))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package doom-themes)
	(setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
(load-theme 'doom-one t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(use-package which-key)
(which-key-mode)
(use-package doom-modeline)
(doom-modeline-mode 1)
(global-visual-line-mode 1)

(use-package dashboard
:init      ;; tweak dashboard config before loading it
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-banner-logo-title "Emacs Is A Fucking Nightmare!")
;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
(setq dashboard-startup-banner "~/.emacs.d/evim.png")  ;; use custom image as banner
(setq dashboard-center-content nil) ;; set to 't' for centered content
(setq dashboard-items '((recents . 5)
                        (agenda . 5 )
                        (bookmarks . 7)
                        (registers . 3)))
:config
(dashboard-setup-startup-hook)
(dashboard-modify-heading-icons '((recents . "file-text")
       (bookmarks . "book"))))

(use-package counsel
       :after ivy
       :config (counsel-mode))
     (use-package ivy
       :defer 0.1
       :diminish
       :bind
       (("C-c C-r" . ivy-resume)
	("C-x B" . ivy-switch-buffer-other-window))
       :custom
       (setq ivy-count-format "(%d/%d) ")
       (setq ivy-use-virtual-buffers t)
       (setq enable-recursive-minibuffers t)
       :config
       (ivy-mode))
     (use-package ivy-rich
       :after ivy
       :custom
       (ivy-virtual-abbreviate 'full
	ivy-rich-switch-buffer-align-virtual-buffer t
	ivy-rich-path-style 'abbrev)
       :config
       (ivy-set-display-transformer 'ivy-switch-buffer
				    'ivy-rich-switch-buffer-transformer)
       (ivy-rich-mode 1)) ;; this gets us descriptions in M-x.
     (use-package swiper
       :after ivy
       :bind (("C-s" . swiper)
	      ("C-r" . swiper)))
     (setq ivy-initial-inputs-alist nil)
(use-package smex)
(smex-initialize)

(defun local/select-start-file ()
  "Open specific file."
  (find-file "~/scratch.org")
)

(use-package vterm)
(setq shell-file-name "/usr/bin/zsh"
    vterm-max-scrollback 5000)

(add-hook 'org-mode-hook 'org-indent-mode)
(setq org-directory "~/dox/org/"
      org-agenda-files '("~/dox/org/agenda.org")
      org-default-notes-file (expand-file-name "notes.org" org-directory)
      org-ellipsis " ▼ "
      org-log-done 'time
      org-journal-dir "~/dox/org/journal/"
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org"
      org-hide-emphasis-markers t)
(setq org-src-preserve-indentation nil
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(setq org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
        '(("google" . "http://www.google.com/search?q=")
          ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
          ("ddg" . "https://duckduckgo.com/?q=")
          ("wiki" . "https://en.wikipedia.org/wiki/")))

(use-package org-tempo
 :ensure nil)
(setq org-src-fontify-natively t
org-src-tab-acts-natively t
org-confirm-babel-evaluate nil
org-edit-src-content-indentation 0)

(use-package toc-org
:commands toc-org-enable
:init (add-hook 'org-mode-hook 'toc-org-enable))

(add-to-list 'load-path "~/.emacs.d/site-lisp/org-present")
(autoload 'org-present "org-present" nil t)

(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))

(use-package pdf-tools)
(use-package lsp-latex)
(use-package mw-thesaurus)
(use-package scanner)

(use-package emms)
(require 'emms-player-simple)
(require 'emms-source-file)
(require 'emms-source-playlist)
(emms-all)
(emms-default-players)
(setq emms-player-list '(emms-player-mpv
                         emms-player-mplayer))
(setq
  emms-source-file-default-directory "~/music/"
  emms-source-playlist-default-format 'mp3
  emms-player-mpv-environment '("PULSE_PROP_media.role=music")
  emms-player-mpv-parameters '("--quiet" "--really-quiet" "--no-audio-display" "--force-window=no" "--vo=null")
  emms-repeat-playlist 1
  emms-playlist-buffer-name "*Music*")

;; if you use `me/magit-status-bare' you cant use `magit-status' on other other repos you have to unset `--git-dir' and `--work-tree'
;; use `me/magit-status' insted it unsets those before calling `magit-status'
(defun me/magit-status ()
  "removes --git-dir and --work-tree in `magit-git-global-arguments' and calls `magit-status'"
  (interactive)
  (require 'magit-git)
  (setq magit-git-global-arguments (remove bare-git-dir magit-git-global-arguments))
  (setq magit-git-global-arguments (remove bare-work-tree magit-git-global-arguments))
  (call-interactively 'magit-status))

(use-package magit)



;; (add-hook 'server-after-make-frame-hook #'local/select-start-file)
