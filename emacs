(tool-bar-mode 0)
;;----------------------------------------------------------------------------
;; Set up syntax highlighting (font-lock)
;;----------------------------------------------------------------------------

(cond ((fboundp 'global-font-lock-mode)
       ;; Turn on font-lock in all modes that support it
       (global-font-lock-mode t)
       ;; Maximum colors
       (setq font-lock-maximum-decoration t)))


(add-hook 'text-mode-hook
          (function
           (lambda ()
             (auto-fill-mode)
             )))

;; Set up frame position and coloring
(setq default-frame-alist
      '(
        (background-color . "white")
  (foreground-color . "blue")
        ))

;;;
;; css mode
(setq cssm-indent-function 'cssm-c-style-indenter)

;;;
;; ruby mode
(autoload 'ruby-mode "ruby-mode" "Load ruby-mode")
(add-hook 'ruby-mode-hook 'turn-on-font-lock)

;; cool tabbing
(global-set-key "\M-g" 'goto-line)
(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)

;; associate ruby-mode with .rb files and .rjs files
(add-to-list 'auto-mode-alist '(".rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '(".rjs$" . ruby-mode))
(add-to-list 'auto-mode-alist '(".rake$" . ruby-mode))

(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
             interpreter-mode-alist))

;; Ruby-Interpreter:
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
    '(lambda ()
       (inf-ruby-keys)
       ))

;; Fuzzy completion
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching


(require 'ruby-electric)

;;;
;; mmm mode for editing rhtml files
(require 'mmm-mode)
(require 'mmm-auto)
(setq mmm-global-mode 'maybe)
(setq mmm-submode-decoration-level 2)
(set-face-background 'mmm-output-submode-face  "Black")
(set-face-background 'mmm-code-submode-face    "Black")
(set-face-background 'mmm-comment-submode-face "Black")
(set-face-foreground 'mmm-output-submode-face "Green")
(set-face-foreground 'mmm-code-submode-face "Green")
(set-face-foreground 'mmm-comment-submode-face "Red")
(mmm-add-classes
 '((erb-code
    :submode ruby-mode
    :match-face (("<%#" . mmm-comment-submode-face)
     ("<%=" . mmm-output-submode-face)
     ("<%"  . mmm-code-submode-face))
    :front "<%[#=]?"
    :back "-?%>"
    :insert ((?% erb-code       nil @ "<%"  @ " " _ " " @ "%>" @)
       (?# erb-comment    nil @ "<%#" @ " " _ " " @ "%>" @)
       (?= erb-expression nil @ "<%=" @ " " _ " " @ "%>" @))
    )))
(add-hook 'html-mode-hook
    (lambda ()
      (setq mmm-classes '(erb-code))
      (mmm-mode-on)))
(add-to-list 'auto-mode-alist '("\\.rhtml$" . html-mode))

;;;
 ;; yaml mode
 (autoload 'yaml-mode "yaml-mode" "YAML" t)
 (setq auto-mode-alist
       (append '(("\\.yml$" . yaml-mode)) auto-mode-alist))

;;;
 ;; rails mode
 (defun try-complete-abbrev (old)
   (if (expand-abbrev) t nil))

 (setq hippie-expand-try-functions-list
       '(try-complete-abbrev
   try-complete-file-name
   try-expand-dabbrev))

 (require 'rails)
 (setq rails-use-mongrel t)

 ;; Do civilized backup names.  Added by dbrady 2003-03-07, taken from
 ;; http://emacswiki.wikiwikiweb.de/cgi-bin/wiki.pl?BackupDirectory
 (setq
  backup-by-copying t         ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/saves"))        ; don't litter my fs tree
     delete-old-versions t
      kept-new-versions 6
       kept-old-versions 2
        version-control t)          ; use versioned backups

 ;; make #! scripts executable after saving them
 (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;;
;; erc irc client related
;(require 'erc-match)
;    (setq erc-keywords '("walter"))

;; ----------------------------------------------------------------------
;; Experimental -- code from Tim Harper to add checkbox to org-mode
;; when hitting M-enter in a checklist

(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
  (save-excursion
    (org-beginning-of-item)
    (when (org-at-item-checkbox-p)
      (ad-set-args 0 '(checkbox)))))

;;if you auto-load emacs... this will patch org-mode after it loads:
(eval-after-load "org-mode"
  '(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
     (save-excursion
       (when (org-at-item-p)
         (org-beginning-of-item)
         (when (org-at-item-checkbox-p)
           (ad-set-args 0 '(checkbox)))))))

(require 'linum)
(global-set-key "\C-c l" 'linum-mode)

(defun enable-linum-mode ()
  (linum-mode t))
(add-hook 'c-mode-hook 'enable-linum-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-linum-mode)
(add-hook 'lisp-mode-hook 'enable-linum-mode)
(add-hook 'nxml-mode-hook 'enable-linum-mode)
(add-hook 'ruby-mode-hook 'enable-linum-mode)
(add-hook 'text-mode-hook 'enable-linum-mode)
(add-hook 'xml-mode-hook 'enable-linum-mode)
(add-hook 'yaml-mode-hook 'enable-linum-mode)
(add-hook 'feature-mode-hook 'enable-linum-mode)


; ----------------------------------------------------------------------
; reload-buffer
; Seriously, why doesn't this already exist? Reloads the current
; buffer.  find-alternate-file will sort of already do this; if you do
; not supply an argument to it it will reload the current
; buffer... but it will switch you to another buffer when it does
; it. All this function does is find-alt and then switch you back.
(defun reload-buffer()
  (interactive)
  (let ((buffername (buffer-name)))
    (find-alternate-file buffername)
    (switch-to-buffer buffername)))
; override the binding for find-alternate-file to be reload-buffer,
; since that's what I always use it for.
(global-set-key (kbd "\C-x C-v") 'reload-buffer)