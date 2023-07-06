;; Initialize package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ensure 'use-package' is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Auto-save on change
(defun save-buffer-if-visiting-file (&optional args)
   "Save the current buffer only if it is visiting a file"
   (interactive)
   (if (and (buffer-file-name) (buffer-modified-p))
       (save-buffer args)))
(add-hook 'auto-save-hook 'save-buffer-if-visiting-file)
(setq auto-save-interval 1)

;; Install and configure dracula theme
(use-package dracula-theme
  :ensure t
  :config
  (load-theme 'dracula t)
  )

;; Switch between Emacs windows
(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window))

;; Switch to treemacs
(defvar previous-window nil
  "Variable to store the previous window.")

(defun switch-to-treemacs ()
  "Switch to the Treemacs window."
  (interactive)
  (if (eq (selected-window) (treemacs-get-local-window))
      (when previous-window
        (select-window previous-window)
        (setq previous-window nil))
    (progn
      (setq previous-window (selected-window))
      (let ((treemacs-win (treemacs-get-local-window)))
        (when treemacs-win
          (select-window treemacs-win))))))

(global-set-key (kbd "M-t") 'switch-to-treemacs)

;; Bind the function to the key sequence "<S-f1>"
(global-set-key (kbd "<S-f1>")
                (lambda ()
                  (interactive)
                  ;; Save all buffers and kill Emacs
                  (save-buffers-kill-emacs 1)))

(eval-after-load "frame"
  '(progn
     ;; This code is evaluated after the "frame" library is loaded
     ;; It ensures that the key binding is set only after the "frame" library is available
     
     ;; Bind Shift + F12 to toggle maximization
     (global-set-key (kbd "<S-f12>") 'toggle-frame-maximized)
     ;; This line sets the key binding for Shift + F12
     ;; which toggles the maximization state of the frame
     ))

(setq default-frame-alist '((undecorated . t)))
;; Set the default frame parameters to make it undecorated (without window decorations)

(add-to-list 'default-frame-alist '(drag-internal-border . 1))
;; Add 'drag-internal-border' parameter to the default frame alist
;; This parameter sets the width (in pixels) of the internal border to 1
;; The internal border is the space between the frame content and the window edges

(add-to-list 'default-frame-alist '(internal-border-width . 5))
;; Add 'internal-border-width' parameter to the default frame alist
;; This parameter sets the width (in pixels) of the internal border to 5
;; The internal border is the space between the frame content and the window edges

;; Install and configure doom-modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  )

;; Disable async compilation warnings
(setq comp-async-warnings nil)

;; Haskell Mode configuration
(use-package haskell-mode
  :ensure t
  :bind (("C-M-x" . haskell-interactive-bring) ;; Bind Haskell REPL to C-M-x
         ("C-f" . ormolu-format-buffer)) ;; Bind formatting to C-f
  :config
  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile)
  )

;; Install and configure ormolu
(use-package ormolu
  :ensure t
  )

;; Hook to bind formatting to C-f in haskell-mode
(add-hook 'haskell-mode-hook
          (lambda ()
            (local-set-key (kbd "C-f") 'ormolu-format-buffer)
            )
          )

;; Enable lsp-mode and configure for haskell-mode
(use-package lsp-mode
  :hook (haskell-mode . lsp-deferred)
  :commands lsp
  :config
  (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
  (setq lsp-haskell-process-args-hie '("-d" "-l" "/tmp/hls.log"))
  (setq lsp-enable-snippet nil) ;; Disable snippet support
  (setq lsp-auto-configure t)
  )

;; Install and configure lsp-haskell
(use-package lsp-haskell
  :ensure t
  :config
  (setq lsp-haskell-server-path "haskell-language-server-wrapper")
  )

;; Enable lsp-ui for additional UI features
(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  )

;; Install and configure company-mode
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (define-key company-active-map (kbd "<escape>") #'hide-company-tooltip)
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  )

;; Function to hide company tooltip
(defun hide-company-tooltip ()
  (interactive)
  (when (company-tooltip-visible-p)
    (company-cancel))
  )

;; Function to disable beep sound
(defun disable-beep-sound ()
  (setq ring-bell-function 'ignore)
  )

;; Disable beep sound
(add-hook 'after-init-hook 'disable-beep-sound)

;; Disable pop-up errors in Haskell mode
(setq haskell-interactive-popup-errors nil)

;; Disable the tool bar
(tool-bar-mode -1)

(use-package all-the-icons
  :ensure t)
;; Use the 'use-package' macro to configure the 'all-the-icons' package
;; The ':ensure t' ensures that the package is installed if not already present

(use-package treemacs
  :ensure t
  :after all-the-icons
  :config
  (require 'treemacs-all-the-icons)
  (treemacs-load-theme "all-the-icons")

  ;; Customize the sizes for Treemacs faces
  (custom-set-faces
   '(treemacs-directory-face ((t (:height 0.90))))
   '(treemacs-file-face ((t (:height 0.80))))
   '(treemacs-root-face ((t (:height 0.90)))))
  )

(use-package treemacs-evil
  :ensure t
  :after treemacs evil)
;; Use the 'use-package' macro to configure the 'treemacs-evil' package
;; The ':ensure t' ensures that the package is installed if not already present
;; The ':after treemacs evil' specifies that the package should be loaded after 'treemacs' and 'evil'

(use-package treemacs-projectile
  :ensure t
  :after treemacs projectile)
;; Use the 'use-package' macro to configure the 'treemacs-projectile' package
;; The ':ensure t' ensures that the package is installed if not already present
;; The ':after treemacs projectile' specifies that the package should be loaded after 'treemacs' and 'projectile'

;; Display Treemacs as a side window on startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (delete-other-windows)
            (treemacs)
            (treemacs-follow-mode t)))

;; Set C-M-s keybinding to toggle side window
(global-set-key (kbd "C-M-s") 'window-toggle-side-windows)

;; Dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-startup-banner nil)
(setq dashboard-banner-logo-title "
            ▓▓▓▓      ▓▓              ▓▓      ▓▓▓▓          
                ▓▓      ██▓▓████▓▓▓▓██      ▓▓              
                ▓▓    ▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓██    ▓▓              
                  ██  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓                
                    ▓▓▓▓▓▓▒▒▒▒▓▓▒▒▒▒░░▒▒▓▓                  
                  ▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒                
                ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓              
                ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒░░▒▒▓▓▓▓              
              ▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▒▒▒▒░░▒▒▓▓▓▓▓▓            
            ▓▓  ▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▒▒▒▒▓▓▒▒▒▒▒▒▓▓  ▓▓          
            ▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▓▓▓▓▒▒▓▓▒▒▒▒  ▓▓          
        ▓▓▒▒    ▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▓▓▓▓▒▒▓▓▒▒▒▒    ▒▒▓▓      
                ▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▒▒▒▒▓▓▒▒▒▒▒▒▒▒              
                ▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▒▒▒▒▒▒░░▒▒▒▒▒▒              
                ▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒              
              ██  ▓▓▓▓▓▓▓▓▓▓▒▒▓▓▒▒▓▓▓▓▒▒▒▒▒▒  ▓▓            
              ▓▓    ▓▓▓▓▓▓▓▓▒▒▓▓▒▒▓▓▓▓▒▒▒▒    ▓▓            
              ▓▓        ▓▓▒▒▒▒▓▓▒▒▒▒▒▒        ▓▓            
                ▓▓                          ▓▓              
                  ▓▓                      ▓▓                
                  ▓▓                      ▓▓                
")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(company use-package treemacs-all-the-icons lsp-ui lsp-haskell flycheck dracula-theme))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(warning-suppress-types '((comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(treemacs-directory-face ((t (:height 0.9))))
 '(treemacs-file-face ((t (:height 0.8))))
 '(treemacs-root-face ((t (:height 0.9)))))
