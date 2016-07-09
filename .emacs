(require 'package)
(setq package-archives
             '(
               ("melpa" . "http://melpa.org/packages/")
               ("marmalade" . "http://marmalade-repo.org/packages/")))


(setq package-list '(autopair markdown-mode use-package scala-mode dirtree multiple-cursors auto-complete))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(cua-mode 1) ;; Para shortcuts familiares

(setq-default indent-tabs-mode nil) ;; Para usar espacios como tabs

(autopair-global-mode)

(require 'use-package)

(use-package ensime
  :commands ensime ensime-mode)

(add-hook 'scala-mode-hook 'ensime-mode)

(require 'dirtree)

(require 'multiple-cursors)

(global-set-key (kbd "C-d") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)

(add-hook 'elm-mode-hook #'elm-oracle-setup-ac)

(setq elm-format-on-save t)
