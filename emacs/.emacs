;; Reminders:
;; Use `clone-indirect-buffer` to duplicate a frame.

;; Performance tweaks
;; ;; https://news.ycombinator.com/item?id=39119835
(setq gc-cons-threshold (* 1024 1024 1024))
;; ;; Trigger a GC after 5s of idle time
(run-with-idle-timer 2 t (lambda () (garbage-collect)))
(setq gcmh-high-cons-threshold (* 1024 1024 1024))
(setq gcmh-idle-delay-factor 20)
(setq jit-lock-defer-time 0.05)
(setq read-process-output-max (* 2 1024 1024)
    process-adaptive-read-buffering nil)
(setq fast-but-imprecise-scrolling t
    redisplay-skip-fontification-on-input t
    inhibit-compacting-font-caches t)
(setq idle-update-delay 1.0)
(setq package-native-compile t)

;; Package management with straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; UI
;; ;; Themes
(straight-use-package 'sublime-themes)
(load-theme 'hickey t)
(set-face-background 'mode-line "gray60")

;; ;; Line numbers
(global-display-line-numbers-mode 1)
(line-number-mode t)
(column-number-mode t)

;; ;; custom-set-faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(line-number ((t (:inherit default :background "gray10" :foreground "gray90")))))

;; ;; Clean up unwanted UI elements.
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(set-fringe-mode 0)
(setq-default fringe-mode 'no-fringes)
(setq inhibit-startup-message t)
(defun display-startup-echo-area-message ()
  (message ""))
(setq visual-bell nil)
(setq ring-bell-function 'ignore)
(setq initial-scratch-message nil)
(setq use-dialog-box nil)
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'yes-or-no-p)

;; ;; Parentheses matching
(show-paren-mode t)
(setq show-paren-delay 0)

;; emacsclient helpers
(global-set-key (kbd "C-x C-c") 'delete-frame) ;; Originally save-buffers-kill-terminal
(global-set-key (kbd "C-x C-z") nil) ;; Originally suspend-frame

;; General editing
;; ;; Helpful aliases
(global-set-key (kbd "C-x C-r") 'revert-buffer)

;; ;; Backups and autosaves in /tmp.
(defun require-directory (directory)
  "Create a directory if it doesn't exist"
  (if (not (file-exists-p directory))
      (make-directory directory)))
(require-directory "/tmp/emacs-backups")
(defun make-backup-file-name (file)
  "Create the backup file name for FILE"
  (concat "/tmp/emacs-backups" (file-name-nondirectory file) "~"))
(require-directory "/tmp/emacs-autosaves")
(defun make-auto-save-file-name ()
  "Return file name to use for auto-saves for current buffer"
  (if buffer-file-name
      (concat "/tmp/emacs-autosaves" "#" (file-name-nondirectory buffer-file-name) "#")
    (concat "/tmp/emacs-autosaves" "#%" (buffer-name) "#")))

;; ;; Delete by moving into trash.
(setq delete-by-moving-to-trash t)

;; ;; Remove trailing whitespace.
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(set-default 'truncate-lines nil)

;; ;; Navigate through camel case and friends.
(global-subword-mode t)

;; ;; Keep a large kill ring.
(setq kill-ring-max 1000)

;; ;; Transient mark mode.
(transient-mark-mode t)

;; ;; CUA mode.
(cua-mode t)
(setq cua-enable-cua-keys nil)
(cua-selection-mode t)

;; ;; Remember recent files
(straight-use-package 'recentf)
(recentf-mode t)
(setq recentf-auto-cleanup 'never)
(run-at-time nil (* 5 60) 'recentf-save-list)

;; ;; Use undo-tree for managing undo.
(straight-use-package 'undo-tree)
;; (require-directory "/tmp/undo-history")
;; (setq undo-tree-history-directory-alist '("." . "/tmp/undo-history"))
(setq undo-tree-auto-save-history nil)
(setq undo-tree-enable-undo-in-region t)
(setq undo-tree-visualizer-diff t)
(global-undo-tree-mode)

;; ;; 100 character columns + 4 space tabs + never tab characters
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq-default fill-column 100)

;; ido configuration
(straight-use-package 'ido)
(ido-mode t)
(setq read-file-name-completion-ignore-case t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-decorations '("\n-> "
                        ""
                        "\n   "
                        "\n   ..."
                        "["
                        "]"
                        " [No match]"
                        " [Matched]"
                        " [Not readable]"
                        " [Too big]"
                        " [Confirm]"))
(defun ido-disable-line-trucation ()
  (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)

;; File picker with `fzf`
(straight-use-package 'fzf)
(global-set-key (kbd "C-x C-z") 'fzf-git-files)

;; Language modes
;; LSP
(straight-use-package 'eglot)

;; ;; Copilot
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el"))
  :ensure t)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; ;; Rust
(straight-use-package 'rust-mode)
(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'copilot-mode)

;; ;; TypeScript
(straight-use-package 'typescript-mode)
(add-hook 'typescript-mode-hook 'eglot-ensure)
(add-hook 'typescript-mode-hook 'copilot-mode)
