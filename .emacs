;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    company
    ein
    elpy
    flycheck
    ;; material-theme;; 默认主题
    monokai-theme;; sublime主题
    hungry-delete;; 删除多余的空格
    swiper;; 让搜索更直观
    counsel;; 与swiper配合
    smartparens;; 智能括号
    popwin;; 打开帮助等第三方窗口时自动跳转到新窗口
    expand-region;; 扩展选中的区域
    iedit;; 智能编辑同样的选中
    py-autopep8))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
;; 这个是推荐的主题
;; (load-theme 'material t) ;; load material theme
;; 这个是subline主题
(load-theme 'monokai t) ;; load material theme

(global-linum-mode t) ;; enable line numbers globally
(setq linum-format "%03d| ")

(display-time-mode 1) ;; 常显 
(setq display-time-24hr-format t) ;;格式 
(setq display-time-day-and-date t) ;;显示时间、星期、日期

(setq ring-bell-fhunction 'ignore)

(menu-bar-mode 0);关闭菜单栏

(global-hl-line-mode 1);显示当前行

(global-company-mode t)
;; ues the recent files
(require 'recentf)
(setq recentf-max-saved-items 25);;default its 20
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

(transient-mark-mode t)
(setq company-minimum-prefix-length 1)

;; 删除多余的空格
(require 'hungry-delete)
(global-hungry-delete-mode)


;; smartparens configuration 智能括号
;; --------------------------------------
(smartparens-global-mode t)
		       

;; swiper configuration快速搜索设置
;; --------------------------------------
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)
(global-set-key (kbd "C-h l") 'counsel-find-library)
(global-set-key (kbd "M-s i") 'counsel-imenu)

;; help configuration
;; --------------------------------------
(global-set-key (kbd "C-h C-k") 'find-function-on-key)
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)

;; popwin configuration 打开帮助等第三方窗口时自动跳转到新窗口
;; -------------------------------------
(require 'popwin)
(popwin-mode t)


;; expand-region configuration扩展选中的区域
;; -------------------------------------
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; 关闭自动备份文件
;; --------------------------------------
(setq make-backup-files nil)


;; 设置语言编码
;; -------------------------------------
(set-language-environment "utf-8")


;; PYTHON CONFIGURATION
;; --------------------------------------
(elpy-enable)
;; (elpy-use-ipython)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)




;; dired-mord中简化yes or no的确认为 y or n的确认
;; ------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (smex swiper monokai-theme company-jedi xref-js2 py-autopep8 material-theme flycheck elpy ein better-defaults hungry-delete counsel swiper))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
