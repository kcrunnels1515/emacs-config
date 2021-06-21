;;; scanner-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "scanner" "scanner.el" (0 0 0 0))
;;; Generated autoloads from scanner.el

(defvar scanner-menu (let ((map (make-sparse-keymap))) (define-key map [image-size] '(menu-item "Select image size" scanner-select-image-size :key-sequence nil :help "Select a size for image scanning.")) (define-key map [img-res] '(menu-item "Set image resolution" scanner-set-image-resolution :key-sequence nil :help "Set the resolution for image scanning.")) (define-key map [languages] '(menu-item "Select OCR languages" scanner-select-languages :key-sequence nil :help "Select languages for OCR.")) (define-key map [outputs] '(menu-item "Select document outputs" scanner-select-outputs :key-sequence nil :help "Select document output formats.")) (define-key map [papersize] '(menu-item "Select paper size" scanner-select-papersize :key-sequence nil :help "Select a paper size for document scanning.")) (define-key map [doc-res] '(menu-item "Set document resolution" scanner-set-document-resolution :key-sequence nil :help "Set the resolution for document scanning.")) (define-key map [select-dev] '(menu-item "Select scanning device" scanner-select-device :key-sequence nil :help "Select a scanning device.")) (define-key map [seperator] '(menu-item "--")) (define-key map [image-multi] '(menu-item "Scan multiple images" scanner-scan-multi-images :key-sequence nil)) (define-key map [image] '(menu-item "Scan an image" scanner-scan-image :key-sequence nil)) (define-key map [document-multi] '(menu-item "Scan a multi-page document" scanner-scan-multi-doc :key-sequence nil)) (define-key map [document] '(menu-item "Scan a document" scanner-scan-document :key-sequence nil)) map) "\
The scanner menu map.")

(define-key-after menu-bar-tools-menu [scanner] (list 'menu-item "Scanner" scanner-menu))

(autoload 'scanner-select-papersize "scanner" "\
Select the papersize SIZE for document scanning.

\(fn SIZE)" t nil)

(autoload 'scanner-select-image-size "scanner" "\
Select the size for image scanning as X and Y dimensions.

\(fn X Y)" t nil)

(autoload 'scanner-select-languages "scanner" "\
Select LANGUAGES for optical character recognition.

\(fn LANGUAGES)" t nil)

(autoload 'scanner-select-outputs "scanner" "\
Select OUTPUTS for tesseract.

\(fn OUTPUTS)" t nil)

(autoload 'scanner-set-image-resolution "scanner" "\
Set the RESOLUTION for scanning images.

\(fn RESOLUTION)" t nil)

(autoload 'scanner-set-document-resolution "scanner" "\
Set the RESOLUTION for scanning documents.

\(fn RESOLUTION)" t nil)

(autoload 'scanner-select-device "scanner" "\
Select a scanning DEVICE.
If a prefix argument is supplied, force auto-detection.
Otherwise, auto-detect only if no devices have been detected
previously.

The selected device will be used for any future scan until a new
selection is made.

\(fn DEVICE)" t nil)

(autoload 'scanner-scan-document "scanner" "\
Scan NPAGES pages and write the result to FILENAME.
Without a prefix argument, scan one page.  With a non-numeric
prefix argument, i.e. ‘\\[universal-argument]
\\[scanner-scan-document]’, scan a page and ask the user for
confirmation to scan another page, etc.  With a numeric prefix
argument, e.g. ‘\\[universal-argument] 3
\\[scanner-scan-document]’, scan that many pages (in this case,
3).

If ‘scanner-device-name’ is nil or this device is unavailable,
attempt auto-detection.  If more than one scanning device is
available, ask for a selection interactively.

\(fn NPAGES FILENAME)" t nil)

(autoload 'scanner-scan-multi-doc "scanner" "\
Scan a multi-page document, writing them to FILENAME.

\(fn FILENAME)" t nil)

(autoload 'scanner-scan-image "scanner" "\
Scan NSCANS images, and write the result to FILENAME.
Without a prefix argument, scan one image.  With a non-numeric
prefix argument, i.e. ‘\\[universal-argument]
\\[scanner-scan-document]’, scan an image and ask the user for
confirmation to scan another image, etc.  With a numeric prefix
argument, e.g. ‘\\[universal-argument] 3
\\[scanner-scan-document]’, scan that many images (in this case,
3).  A numerical suffix is added to FILENAME for each scanned
image.

If ‘scanner-device-name’ is nil or this device is unavailable,
attempt auto-detection.  If more than one scanning device is
available, ask for a selection interactively.

\(fn NSCANS FILENAME)" t nil)

(autoload 'scanner-scan-multi-images "scanner" "\
Scan multiple images, writing them to FILENAME.
A numerical suffix is added to FILENAME for each scanned image.

\(fn FILENAME)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "scanner" '("scanner-")))

;;;***

;;;### (autoloads nil nil ("scanner-pkg.el" "scanner-test.el") (0
;;;;;;  0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; scanner-autoloads.el ends here
