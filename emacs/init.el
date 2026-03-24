;; Emacs 30 config

;; Package setup (use-package is built-in)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

;; Clean UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

;; Line numbers and parens
(global-display-line-numbers-mode 1)
(show-paren-mode 1)

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

;; Completion (built-in fido-mode replaces ido)
(fido-vertical-mode 1)

;; Keep backup/autosave files out of the way
(setq backup-directory-alist '(("." . "/tmp/emacs-backups"))
      auto-save-file-name-transforms '((".*" "/tmp/emacs-autosaves/" t)))
(make-directory "/tmp/emacs-backups" t)
(make-directory "/tmp/emacs-autosaves" t)

;; Basic editing preferences
(setq use-short-answers t)
(setq-default indent-tabs-mode nil)
(electric-pair-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(global-subword-mode 1)

;; Undo-tree (visual undo history with C-x u)
(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-history-directory-alist '(("." . "/tmp/undo-tree-history"))))

;; Reload init.el
(defun reload-init ()
  "Reload ~/.config/emacs/init.el."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory))
  (message "init.el reloaded."))

;; Keybindings
(global-set-key (kbd "C-x C-c") 'delete-frame)   ;; close frame, not all of emacs (useful with daemon)
(global-set-key (kbd "C-x C-z") 'project-find-file) ;; fuzzy find file in project
(global-set-key (kbd "C-x C-r") 'revert-buffer)

;; Add cargo bin to PATH (for rust-analyzer, etc.)
(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))

;; Git
(use-package magit)

;; Justfile
(use-package just-mode)

;; Rust (tree-sitter mode + eglot)
(use-package rust-mode
  :hook (rust-mode . eglot-ensure))

;; Eglot keybindings (C-c l prefix not available until Emacs 31)
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c a") 'eglot-code-actions))

;; Commands to remember:
;;
;; Project (C-x p prefix):
;;   C-x C-z     find file in project (custom binding)
;;   C-x p g     grep across project
;;   C-x p b     switch between project buffers
;;   C-x p d     dired in project root
;;   C-x p p     switch projects
;;
;; LSP (eglot):
;;   M-.         go to definition
;;   M-,         go back
;;   M-?         find references
;;   C-c r       rename symbol
;;   C-c a       code actions
;;
;; Magit (see below for workflow):
;;   C-x g       magit-status (main entry point)
;;   In status buffer: see magit section below

;; MCP server (lets Claude Code introspect emacs via eval-elisp and get-diagnostics)
(add-to-list 'load-path (expand-file-name "site-lisp/emacs-mcp-server" user-emacs-directory))
(require 'mcp-server)
(setq mcp-server-security-dangerous-functions nil)
(when (fboundp 'mcp-server-stop) (ignore-errors (mcp-server-stop)))
(mcp-server-start-unix)

;; Server managed by systemd: systemctl --user enable --now emacs
;; Open frames with: emacsclient -c (or alias 'e' in .bashrc)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(doom-themes ef-themes just-mode rust-mode undo-tree)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
