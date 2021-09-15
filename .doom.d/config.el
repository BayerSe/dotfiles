;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Sebastian Bayer"
      user-mail-address "bayerse@gmail.com")

;;;; Visual appearance
(setq doom-theme 'doom-one)

;;;; org-mode
;; Insert link when adding an attachment
;(setq org-attach-store-link-p 'attached)    

;; Ensure logging intwo drawer
(setq org-log-into-drawer t)


;; Fold to region as in workflowy, see https://www.reddit.com/r/emacs/comments/b8jqor/making_orgmode_narrowing_as_intuitive_as_workflow/
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


;;;; org-roam

;; copied from modules/config/default/+evil-bindings.el
(map! :leader
      (:prefix ("r" . "roam")
       :desc "Open random node"           "a" #'org-roam-node-random
       :desc "Find node"                  "f" #'org-roam-node-find
       :desc "Find ref"                   "F" #'org-roam-ref-find
       :desc "Show graph"                 "g" #'org-roam-graph
       :desc "Insert node"                "i" #'org-roam-node-insert
       :desc "Capture to node"            "n" #'org-roam-capture
       :desc "Toggle roam buffer"         "r" #'org-roam-buffer-toggle
       :desc "Launch roam buffer"         "R" #'org-roam-buffer-display-dedicated
       :desc "Sync database"              "s" #'org-roam-db-sync
       (:prefix ("d" . "by date")
        :desc "Goto previous note"        "b" #'org-roam-dailies-goto-previous-note
        :desc "Goto date"                 "d" #'org-roam-dailies-goto-date
        :desc "Capture date"              "D" #'org-roam-dailies-capture-date
        :desc "Goto next note"            "f" #'org-roam-dailies-goto-next-note
        :desc "Goto tomorrow"             "m" #'org-roam-dailies-goto-tomorrow
        :desc "Capture tomorrow"          "M" #'org-roam-dailies-capture-tomorrow
        :desc "Capture today"             "n" #'org-roam-dailies-capture-today
        :desc "Goto today"                "t" #'org-roam-dailies-goto-today
        :desc "Capture today"             "T" #'org-roam-dailies-capture-today
        :desc "Goto yesterday"            "y" #'org-roam-dailies-goto-yesterday
        :desc "Capture yesterday"         "Y" #'org-roam-dailies-capture-yesterday
        :desc "Find directory"            "-" #'org-roam-dailies-find-directory)))


;; Update timestamp on save
(add-hook 'org-mode-hook (lambda ()
                             (setq-local time-stamp-active t
                                         time-stamp-line-limit 8
                                         time-stamp-start "^#\\+last_modified: [ \t]*"
                                         time-stamp-end "$"
                                         time-stamp-format "\[%Y-%m-%d %a %H:%M:%S\]")
                             (add-hook 'before-save-hook 'time-stamp nil 'local)))


;; Capture templates
(setq org-roam-capture-templates
      '(
        ("t" "topic" plain "%?"
         :if-new (file+head "topic/${slug}.org"
                            "#+title: ${title}\n#+created: %u\n#+last_modified: <>\n")
         :unnarrowed t)
        ("p" "people" plain "%?"
         :if-new (file+head "people/${slug}.org"
                            "#+title: ${title}\n#+created: %u\n#+last_modified: <>\n")
         :unnarrowed t)
        ("r" "bibliography reference" plain "%?"
         :if-new (file+head "references/${citekey}.org"
                            "#+title: ${title}\n#+created: %u\n#+last_modified: <>\n")
        :unnarrowed t)
        ))


;; org-roam ui
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
    :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))


(use-package! org-roam-bibtex
  :after org-roam
  :config
  (require 'org-ref)) ; optional: if Org Ref is not loaded anywhere else, load it here


(setq bibtex-completion-bibliography
      '("/home/sebastian/org/roam/library.bib"))
