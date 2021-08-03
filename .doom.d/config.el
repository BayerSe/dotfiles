;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sebastian Bayer"
      user-mail-address "bayerse@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(setq org-log-into-drawer t)
(setq org-cycle-emulate-tab 'white)


(after! org
  ;; Clear Doom's default templates
  (setq org-capture-templates '())

  (add-to-list 'org-capture-templates
               `("b" "Add book" entry (file+headline "~/org/notes.org" "Books to read")
                 ;;"* TODO %?\n%i"i
                 "* SOMEDAY Book: %^{Author} - %^{Titel}\n  :PROPERTIES:\n  :Author: %\\1\n  :Title: %\\2\n  :END:\n  :LOGBOOK:\n  - Recommended by: %?\n  - Added: %U\n  :END:"
                 ))
  )


;; Improve org-mode folding
(after! org
  (defun vimacs/org-narrow-to-subtree
    ()
  (interactive)
  (let ((org-indirect-buffer-display 'current-window))
    (if (not (boundp 'org-indirect-buffer-file-name))
        (let ((above-buffer (current-buffer))
              (org-filename (buffer-file-name)))
          (org-tree-to-indirect-buffer (1+ (org-current-level)))
          (setq-local org-indirect-buffer-file-name org-filename)
          (setq-local org-indirect-above-buffer above-buffer))
      (let ((above-buffer (current-buffer))
            (org-filename org-indirect-buffer-file-name))
        (org-tree-to-indirect-buffer (1+ (org-current-level)))
        (setq-local org-indirect-buffer-file-name org-filename)
        (setq-local org-indirect-above-buffer above-buffer)))))

(defun vimacs/org-widen-from-subtree
    ()
  (interactive)
  (let ((above-buffer org-indirect-above-buffer)
        (org-indirect-buffer-display 'current-window))
    (kill-buffer)
    (switch-to-buffer above-buffer)))

(define-key org-mode-map (kbd "<M-tab>") 'vimacs/org-narrow-to-subtree)
(define-key org-mode-map (kbd "<M-iso-lefttab>") 'vimacs/org-widen-from-subtree)

)


;; org-roami


; Update timestamp on save
(add-hook 'org-mode-hook (lambda ()
                             (setq-local time-stamp-active t
                                         time-stamp-line-limit 8
                                         time-stamp-start "^#\\+last_modified: [ \t]*"
                                         time-stamp-end "$"
                                         time-stamp-format "\[%Y-%m-%d %a %H:%M:%S\]")
                             (add-hook 'before-save-hook 'time-stamp nil 'local)))


(setq org-roam-v2-ack t)
(use-package! org-roam
  :after org
 ; :commands
  ;(org-roam-buffer
  ; org-roam-setup
   ;org-roam-capture
   ;org-roam-node-find)
  :config
  ;;(setq org-roam-mode-sections
  ;;      (list #'org-roam-backlinks-insert-section
  ;;            #'org-roam-reflinks-insert-section
  ;;            #'org-roam-unlinked-references-insert-section))
  (org-roam-setup))


(map! :leader
      (:prefix ("r" . "org-roam")
        :desc "Find node"                       "f" #'org-roam-node-find
        :desc "Insert node"                     "i" #'org-roam-node-insert
        :desc "Graph"                           "g" #'org-roam-graph
        :desc "Capture"                         "c" #'org-roam-capture
        :desc "Daily today"                     "t" #'org-roam-dailies-find-today
        :desc "Daily select day"                "d" #'org-roam-dailies-find-date
        ))

(setq org-roam-capture-templates
      '(
        ("d" "default" plain "%?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)
        ("t" "topic" plain "%?"
         :if-new (file+head "topic/${slug}.org"
                            "#+title: ${title}\n#+created: %u\n#+last_modified: <>\n")
         :unnarrowed t)
        ("p" "people" plain "%?"
         :if-new (file+head "people/${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ))

;; Insert link when adding an attachment
(setq org-attach-store-link-p 'attached)
