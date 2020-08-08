;;; org-capture-ref.el --- Extract bibtex info from captured websites  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Ihor Radchenko

;; Author: Ihor Radchenko <yantar92@gmail.com>
;; Keywords: tex, multimedia, bib

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a wrapper to `org-capture-templates' that automatically
;; extracts useful meta-information from the captured URLs. The
;; information is saved into bitex entry and can be reused to fill the
;; capture template.

;;; Code:

(require 'org-capture)
(require 'org-ref-url-utils)
(require 'bibtex)

;;; Customization:

(defgroup org-capture-ref nil
  "Generation of bibtex info for captured webpages."
  :tag "Org capture bibtex generator"
  :group 'org-capture)

(defcustom org-capture-ref-get-buffer-functions '(org-capture-ref-get-buffer-from-html-file-in-query
				   org-capture-ref-retrieve-url)
  "Functions used to retrieve html buffer for the captured link.

Each function will be called without arguments in sequence.
First non-nil return value of these functions will be used as buffer
containing html source of the link.

These functions will be called only when `org-capture-ref-get-buffer' is invoked from anywhere."
  :type 'hook
  :group 'org-capture-ref)

(defcustom org-capture-ref-get-bibtex-functions '()
  "Functions used to generate bibtex entry for captured link.

Each function will be called without arguments in sequence.
The functions are expected to use `org-capture-ref-set-bibtex-field'
and `org-capture-ref-set-capture-info'. to set the required bibtex
fields. `org-capture-ref-get-bibtex-field' and `org-capture-ref-get-capture-info' can
be used to retrieve information about the captured link.
Any function can throw an error and abort the capture process.
Any function can throw `:finish'. All the remaining functions from
this list will not be called then.

If any of the listed functions modifies :key field of the `org-capture-ref-bibtex-alist',
the field will be overwritten by functions from `org-capture-ref-generete-key-functions'."
  :type 'hook
  :group 'org-capture-ref)

(defcustom org-capture-ref-get-bibtex-from-elfeed-functions '()
  "Functions used to generate BibTeX entry from elfeed entry data defined in `:elfeed-data' field of the `org-protocol' capture query.

This variable is only used if `org-capture-ref-get-bibtex-from-elfeed-data' is listed in `org-capture-ref-get-bibtex-functions'.
The functions must follow the same rules as `org-capture-ref-get-bibtex-functions', but will be called with a single argument - efleed entry object.

These functions will only be called if `:elfeed-data' field is present in `:query' field of the `org-store-link-plist'.")

(defcustom org-capture-ref-clean-bibtex-hook '()
  "Normal hook containing functions used to cleanup BiBTeX entry string.

Each function is called with point at undefined position inside buffer
containing a single BiBTeX entry.  The buffer is set to `bibtex-mode'.

The functions have access to `org-capture-ref-get-bibtex-field' and
`org-capture-ref-set-bibtex-field', but there is no guarantee that the
returned value is (or will be) in sync with the BiBTeX entry in the
buffer. It is recommended to use `bibtex-set-field' or
`bibtex-parse-entry' directly.

The new BiBTeX string will be parsed back into the BiBTeX data
structure, and thus may affect anything set by
`org-capture-ref-set-bibtex-field'."
  :type 'hook
  'group org-capture-ref)

(defcustom org-capture-ref-get-formatted-bibtex-functions '()
  "Functions used to format BiBTeX entry string.

Each function will be called without arguments in sequence.
`org-capture-ref-get-bibtex-field' and `org-capture-ref-get-capture-info' can
be used to retrieve information about the captured link.
Return value of the first function returning non-nil will be used as final format."
  :type 'hook
  :group 'org-capture-ref)

(defcustom org-capture-ref-generate-key-functions '()
  "Functions used to generate citation key.
The functions will be called in sequence until any of them returns non-nil value."
  :type 'hook
  :group 'org-capture-ref)

(defcustom org-capture-ref-check-bibtex-functions '()
  "Functions used to check the validity of generated BiBTeX.
  
The functions are called in sequence without arguments.
Any function can throw an error and abort the capture process.
Any function can throw `:finish'. All the remaining functions from
this list will not be called then."
  :type 'hook
  :group 'org-capture-ref)

;; Customisation for default functions

(defcustom org-capture-ref-field-regexps '((:doi . ("scheme=\"doi\" content=\"\\([^\"]*\\)\""
				     "citation_doi\" content=\"\\([^\"]*\\)\""
				     "data-doi=\"\\([^\"]*\\)\""
				     "content=\"\\([^\"]*\\)\" name=\"citation_doi"
				     "objectDOI\" : \"\\([^\"]*\\)\""
				     "doi = '\\([^']*\\)'"
				     "\"http://dx.doi.org/\\([^\"]*\\)\""
				     "/doi/\\([^\"]*\\)\">"
				     "doi/full/\\(.*\\)&"
				     "doi=\\([^&]*\\)&amp"))
                            (:year . ("<[a-z].+ class=\\(.?+date.[^>]*\\)>\\([[:ascii:][:nonascii:]]*?\\)</[a-z].+>"))
                            (:author . ("\\(?:<meta name=\"author\" content=\"\\(.+\\)\" ?/?>\\)\""
					"\\(?:<[^>]*?class=\"author[^\"]*name\"[^>]*>\\([^<]+\\)<\\)"))
                            (:title . ("<title.?+?>\\([[:ascii:][:nonascii:]]*?\\|.+\\)</title>")))
  "Alist holding regexps used by `org-capture-ref-parse-generic' to populate common BiBTeX fields from html.
Keys of the alist are the field names (example: `:author') and the values are lists or regexps.
The regexps are searched one by one in the html buffer and the group 1 match is used as value in the BiBTeX field."
  :group 'org-capture-ref
  :type '(alist :key-type symbol :value-type (list string)))

(defcustom org-capture-ref-default-type "misc"
  "Default BiBTeX type of the captured entry."
  :group 'org-capture-ref
  :type 'string)


(defvar org-capture-ref--store-link-plist nil
  "A copy of `org-store-link-plist'.
The following keys are recognized by generic parser (though all
available keys can be accessed by user-defined parsers):
:link                 Captured link
:description          Page title, as given to org-capture
:query                Query provided to `org-protocol-capture'. The following special fields are recognized:
  :html               Path to html file containing the page. Providing
                      this will speed up processing since there will be no need to download
                      the link contents.
  :qutebrowser-fifo   Path to FIFO communicating with qutebrowser instance
  :elfeed-data        Elfeed entry containing the information about captured URL.")

(defvar org-capture-ref--html-buffer nil
  "Buffer containing downloaded webpage being captured.")

(defvar org-capture-ref--bibtex nil
  "Alist containing bibtex fields for the webpage being captured.
The fields include:
:author       - the author of the URL contents
:title        - title of the URL contents
:url          - cleaned-up URL
:year         - publication year
:urldate      - capture time
:journal      - journal name (for journal articles and books)
:howpublished - website name (for generic URLs).")

(provide 'org-capture-ref)
;;; org-capture-ref.el ends here
