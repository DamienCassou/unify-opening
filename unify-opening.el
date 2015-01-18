;;; unify-opening.el --- Make everything use the same mechanism to open files

;; Copyright (C) 2015 Damien Cassou

;; Author: Damien Cassou <damien.cassou@gmail.com>
;; Url: https://github.com/DamienCassou/unify-opening
;; GIT: https://github.com/DamienCassou/unify-opening
;; Version: 0.1
;; Package-Requires: ((emacs "24.4"))
;; Created: 16 Jan 2015
;; Keywords: dired org mu4e open runner extension file

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Make everything use the same mechanism to open files. Currently,
;; `dired` has its mechanism, `org-mode` uses something different (the
;; `org-file-apps` variable), and `mu4e` something else (a simple
;; prompt). This package makes sure that each package uses the
;; mechanism of `dired`. I advise you to install the
;; [`runner`](https://github.com/thamer/runner) package to improve the
;; `dired` mechanism.

;;; Code:

(defun unify-opening-find-cmd (file)
  "Return a string representing the best command to open FILE.
This method uses `dired-guess-shell-command'.  The runner package, which I
  recommend, will modify the behavior of `dired-guess-shell-command' to
  work better."
  (require 'dired-x)
  (dired-guess-shell-command (format  "Open %s " file) (list file)))

(defun unify-opening-open (file &optional cmd)
  "Open FILE with CMD if provided, ask for best CMD if not.
Asking for best CMD to use to open FILE is done through
`unify-opening-find-cmd'."
  (let ((cmd (or cmd (unify-opening-find-cmd file))))
    (require 'dired-aux)
    (dired-do-async-shell-command cmd 0 (list file))))

(with-eval-after-load "org"
  (add-to-list 'org-file-apps '(t . (unify-opening-open file))))

(with-eval-after-load "mu4e"
  (defun unify-opening-mu4e-view-open-attachment-with (args)
    "Use unify-opening to select which command to open attachments with."
    (let* ((msg (car args))        ;; 1st original argument
           (attachnum (cadr args)) ;; 2nd original argument
           (cmd (car (cddr args))) ;; 3rd original argument
           (attachment (mu4e~view-get-attach msg attachnum))
           (attachment-filename (plist-get attachment :name)))
      (list msg
            attachnum
            (or cmd
                (unify-opening-find-cmd attachment-filename)))))

  (advice-add
   'mu4e-view-open-attachment-with
   :filter-args
   #'unify-opening-mu4e-view-open-attachment-with))

(provide 'unify-opening)

;;; unify-opening.el ends here
