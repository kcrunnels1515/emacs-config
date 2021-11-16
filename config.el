(setq eaf-enable 1)

(setq make-backup-files nil)

(setq visible-bell nil)
(defun ring-bell-function ()
    (message "%s" (propertize "Ding!" 'face '(:foreground "red")))
    )

(setq
eshell-rc-script "~/.emacs.d/eshell.rc"
;;(eshell-login-script "~/.emacs.d/eshell.login")
)

(setq package-native-compile t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

;;(package-refresh-contents)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)

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
              '(
                ("google" . "http://www.google.com/search?q=")
                ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
                ("ddg" . "https://duckduckgo.com/?q=")
                ("wiki" . "https://en.wikipedia.org/wiki/")
                ("dox" . "/home/kellyr/dox")
                )
)

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

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "/home/kellyr/dox/org"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))
  (setq org-roam-v2-ack t)

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

(load-file "~/.emacs.d/site-lisp/yow.elc")

(defun kcr/run-compiler-on-line ()
  (interactive)
  (save-buffer)
  (shell-command-on-region (line-beginning-position)
                           (line-end-position)
                           (format "compiler %s" buffer-file-name)))
(defun kcr/pkg-update ()
(interactive)
  (package-refresh-contents)
  (cd "/home/kellyr/.emacs.d/site-lisp/emacs-application-framework")
  (shell-command "git fetch origin && git reset --hard origin/master")
)

(defun kcr/other-buff-to-split ()
  (interactive)
  (ivy-read "Switch to buffer: " (counsel-ibuffer--get-buffers)
            :history 'counsel-ibuffer-history
            :action #'kcr/other-buff-to-split-1))

(defun kcr/other-buff-to-split-1 (x)
  (evil-window-vsplit)
  (evil-buffer (cdr x)))

(defun kcr/open-with (arg)
  "Open visited file in default external program.
When in dired mode, open file under the cursor.
With a prefix ARG always prompt for command to use."
  (interactive "P")
  (let* ((current-file-name
          (if (eq major-mode 'dired-mode)
              (dired-get-file-for-visit)
            buffer-file-name))
         (open (pcase system-type
                 (`darwin "open")
                 ((or `gnu `gnu/linux `gnu/kfreebsd) "rifle")))
         (program (if (or arg (not open))
                      (read-shell-command "Open current file with: ")
                    open)))
    (call-process program nil 0 nil current-file-name)))

(defun kcr/insert-link-to-file (&optional filename)
  "Insert file as org link."
  (interactive)
  (let ((value (car (find-file-read-args "Choose file: " nil))))
    (insert "[[" value "][filename]]" )
    )
)

(defun kcr/elisp-edit ()
  "Toggle emacs lisp editing mode"
  (interactive)
  (emacs-lisp-mode)
  (electric-pair-local-mode)
)

(defun kcr/wrap-eqn ()
"Wrap equation in org-mode markers"
  (interactive)
  (let ((point1 (region-beginning))
	(point2 (+ 2 (region-end))))
    (goto-char point1)
    (insert "\\" "\(")
    (goto-char point2)
    (insert "\\" "\)")))

(defun client-save-kill-emacs(&optional display)
  " This is a function that can bu used to save buffers and 
shutdown the emacs daemon. It should be called using 
emacsclient -e '(client-save-kill-emacs)'.  This function will
check to see if there are any modified buffers, active clients
or frame.  If so, an x window will be opened and the user will
be prompted."

  (let (new-frame modified-buffers active-clients-or-frames)

    ; Check if there are modified buffers, active clients or frames.
    (setq modified-buffers (modified-buffers-exist))
    (setq active-clients-or-frames ( or (> (length server-clients) 1)
					(> (length (frame-list)) 1)
				       ))  

    ; Create a new frame if prompts are needed.
    (when (or modified-buffers active-clients-or-frames)
      (when (not (eq window-system 'x))
	(message "Initializing x windows system.")
	(x-initialize-window-system))
      (when (not display) (setq display (getenv "DISPLAY")))
      (message "Opening frame on display: %s" display)
      (select-frame (make-frame-on-display display '((window-system . x)))))

    ; Save the current frame.  
    (setq new-frame (selected-frame))


    ; When displaying the number of clients and frames: 
    ; subtract 1 from clients (this client).
    ; subtract 2 from frames (the frame just created and the default frame.)
    (when (or (not active-clients-or-frames)
	       (yes-or-no-p (format "There are currently %d clients and %d frames. Exit anyway?" (- (length server-clients) 1) (- (length (frame-list)) 2)))) 
      
      ; If the user quits during the save dialog then don't exit emacs.
      ; Still close the terminal though.
      (let((inhibit-quit t))
             ; Save buffers
	(with-local-quit
	  (save-some-buffers)) 
	      
	(if quit-flag
	  (setq quit-flag nil)  
          ; Kill all remaining clients
	  (progn
	    (dolist (client server-clients)
	      (server-delete-client client))
		 ; Exit emacs
	    (kill-emacs))) 
	))

    ; If we made a frame then kill it.
    (when (or modified-buffers active-clients-or-frames) (delete-frame new-frame))
    )
  )


(defun modified-buffers-exist() 
  "This function will check to see if there are any buffers
that have been modified.  It will return true if there are
and nil otherwise. Buffers that have buffer-offer-save set to
nil are ignored."
  (let (modified-found)
    (dolist (buffer (buffer-list))
      (when (and (buffer-live-p buffer)
		 (buffer-modified-p buffer)
		 (not (buffer-base-buffer buffer))
		 (or
		  (buffer-file-name buffer)
		  (progn
		    (set-buffer buffer)
		    (and buffer-offer-save (> (buffer-size) 0))))
		 )
	(setq modified-found t)
	)
      )
    modified-found
    )
  )

(defmacro kcr/key (keychord command)
  "Insert a keybinding."
  `(global-unset-key (kbd ,keychord))
  `(global-set-key (kbd ,keychord) ',command)
)

(use-package general
 :config
 (general-evil-setup t))
(global-unset-key (kbd "C-i"))
(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)
(global-set-key (kbd "C-x b") #'counsel-ibuffer)
(global-set-key (kbd "C-x a q") #'evil-delete-buffer)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c C-l") #'org-insert-link)
(global-set-key (kbd "C-x a a") #'append-to-buffer)
(global-set-key (kbd "C-c o") #'kcr/open-with)
(global-set-key (kbd "C-c C-i") #'kcr/insert-link-to-file)

(nvmap :prefix "SPC"
"r p" #'kcr/pkg-update
"r c" #'((lambda () (interactive) (load-file "~/.emacs.d/init.el")) :which-key "Reload emacs config")
"e c" #'kcr/run-compiler-on-line
"e l" #'kcr/other-buff-to-split
"e o" 'org-latex-export-to-pdf
"e p" 'print-buffer
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

(use-package exwm)
;;(use-package exwm-float)
(use-package exwm-mff)
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
(require 'exwm-randr)

(setq exwm-randr-workspace-output-plist '(0 "VGA-1" 1 "HDMI-1"))
(add-hook 'exwm-randr-screen-change-hook
           (lambda ()
             (start-process-shell-command "xrandr" nil "xrandr --output VGA-1 --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-1 --mode 1280x800 --pos 1366x0 --rotate normal")))
(exwm-randr-enable)
(add-hook 'exwm-update-class-hook
          (lambda ()
          (exwm-workspace-rename-buffer exwm-class-name)))
(require 'exwm-systemtray)
(exwm-systemtray-enable)
(setq user-full-name "Kelly Runnels"
      user-mail-address "runnelk@patriots.cf.edu")
(exwm-enable)

;; (add-hook 'server-after-make-frame-hook #'local/select-start-file)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-i") nil))

;; IDO sucks ass
(with-eval-after-load 'ido
(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)
(define-key (cdr ido-minor-mode-map-entry) [remap kill-buffer] nil)
(define-key (cdr ido-minor-mode-map-entry) [remap insert-file] nil)
(define-key (cdr ido-minor-mode-map-entry) [remap insert-buffer] nil)
(define-key (cdr ido-minor-mode-map-entry) [remap find-alternative-file] nil))
