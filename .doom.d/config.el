;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Sebastian Bayer"
      user-mail-address "bayerse@gmail.com")

;;;; Visual appearance
(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)


;;;; org-mode
(setq org-directory "~/org/")

;; Insert link when adding an attachment
(setq org-attach-store-link-p 'attached)    

;; Ensure logging intwo drawer
(setq org-log-into-drawer t)

;; Allow folding from text below headline
(setq org-cycle-emulate-tab 'white)

;; Capture templates
(after! org
  (setq org-capture-templates '())  ; Clear Doom's default templates

  (add-to-list 'org-capture-templates
               `("b" "Add book" entry (file+headline "~/org/notes.org" "Books to read")
                 "* SOMEDAY Book: %^{Author} - %^{Titel}\n  :PROPERTIES:\n  :Author: %\\1\n  :Title: %\\2\n  :END:\n  :LOGBOOK:\n  - Recommended by: %?\n  - Added: %U\n  :END:"
                 ))
  )

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
(setq org-roam-v2-ack t)

(use-package! org-roam
  :after org
  :config
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
