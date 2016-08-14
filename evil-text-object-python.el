;;; evil-text-object-python.el --- Python specific evil text objects -*- lexical-binding: t; -*-

;; Author: Wouter Bolsterlee <wouter@bolsterl.ee>
;; Version: 1.0.0
;; Package-Requires: ((emacs "24") (evil "1.2.12"))
;; Keywords: evil python text-object
;; URL: https://github.com/wbolster/evil-text-object-python
;;
;; This file is not part of GNU Emacs.

;;; License:

;; Licensed under the same terms as Emacs.

;;; Commentary:

;; This package provides text objects for Python statements for use
;; with evil-mode.  See the README for more details.

;;; Code:

(require 'evil)

(defgroup evil-text-object-python nil
  "Evil text objects for Python"
  :prefix "evil-text-object-python-"
  :group 'evil)

(defcustom evil-text-object-python-statement-key "l"
  "Key to use for a Python statement in the text object maps."
  :type 'string
  :group 'evil-text-object-python)

(defun evil-text-object-python--detect-key(containing-map child)
  "Detect which key in CONTAINING-MAP maps to CHILD."
  ;; Note: this only uses the single match.
  (key-description (car (where-is-internal child containing-map))))

(defun evil-text-object-python--define-key (key text-objects-map text-object)
  "Bind KEY in TEXT-OBJECTS-MAP to TEXT-OBJECT."
  ;; Note: this only defines keys in local keymaps and does not change
  ;; the global text object maps. First detect the prefixes used in
  ;; the global maps (defaults are "i" for the inner text objects map,
  ;; and "a" for the outer text objects map), and use the same prefix
  ;; for the local bindings.
  (define-key evil-operator-state-local-map
    (kbd (format "%s %s" (evil-text-object-python--detect-key evil-operator-state-map text-objects-map) key))
    text-object)
  (define-key evil-visual-state-local-map
    (kbd (format "%s %s" (evil-text-object-python--detect-key evil-visual-state-map text-objects-map) key))
    text-object))

(defun evil-text-object-python--make-text-object (count type)
  "Helper to make text object for COUNT Python statements of TYPE."
  (let ((beg (save-excursion
               (python-nav-beginning-of-statement)
               (when (or (eq this-command 'evil-delete) (eq type 'line))
                 (beginning-of-line))
               (point)))
        (end (save-excursion
               (dotimes (number (1- count))
                 (python-nav-forward-statement))
               (python-nav-end-of-statement)
               (when (eq type 'line)
                 (condition-case nil
                     (progn (next-line) (beginning-of-line))
                   (end-of-buffer nil)))
               (point))))
    (evil-range beg end)))

(evil-define-text-object
  evil-text-object-python-inner-statement (count &optional beg end type)
  "Inner text object for the Python statement under point."
  (evil-text-object-python--make-text-object count type))

(evil-define-text-object
  evil-text-object-python-outer-statement (count &optional beg end type)
  "Outer text object for the Python statement under point."
  :type line
  (evil-text-object-python--make-text-object count type))

;;;###autoload
(defun evil-text-object-python-add-bindings ()
  "Add text object key bindings.

This function should be added to a major mode hook.  It modifies
buffer-local keymaps and adds bindings for Python text objects for
both operator state and visual state."
  (evil-text-object-python--define-key
   evil-text-object-python-statement-key
   evil-inner-text-objects-map
   'evil-text-object-python-inner-statement)
  (evil-text-object-python--define-key
   evil-text-object-python-statement-key
   evil-outer-text-objects-map
   'evil-text-object-python-outer-statement))

(provide 'evil-text-object-python)
;;; evil-text-object-python.el ends here
