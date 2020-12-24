
# Table of Contents

1.  [Auto-generating BiBTeX for more than just books and papers](#orgec15963)
    1.  [Installation](#orgda78390)
        1.  [Using straight.el](#orga8d2a2a)
        2.  [Using quelpa](#org3bff520)
        3.  [Using direct download](#orgc014900)
    2.  [Usage](#orgefc6069)
        1.  [Capture setup](#orge7a2e55)
        2.  [Capturing links from browser](#org8f9ea41)
        3.  [Capturing rss links from elfeed](#org9eb50e8)
    3.  [Extra features](#org0c734a4)
        1.  [Detecting existing captures](#orgdc85d9c)
        2.  [Integration with qutebrowser](#qute_integration)
    4.  [Customisation](#org92f8b3d)
        1.  [Retrieving BiBTeX fields](#org092cba4)
        2.  [Key generation](#org756f6b7)
        3.  [Formatting BiBTeX entry](#org2c11c38)
        4.  [Validating the BiBTeX entry](#orga99ff02)
    5.  [Planned features](#org4535dac)


<a id="orgec15963"></a>

# Auto-generating BiBTeX for more than just books and papers

This package is inspired by [org-ref](https://github.com/jkitchin/org-ref), extending org-ref's idea to auto-retrieve BiBTeX from scientific paper links. Instead of limiting BiBTeX generation to research purposes (scientific articles and books), this package auto-generates BiBTeX for any possible web link (Youtube videos, blog posts, reddit threads, etc).

Unlike `org-ref`, this package is designed to be used together with [org-capture](https://orgmode.org/manual/Capture.html#Capture). The package is created assuming that the links/articles/books are captured from web sources using the following methods:

-   [org-protocol](https://orgmode.org/manual/The-capture-protocol.html#The-capture-protocol) from system browser
-   org-protocol from [elfeed](https://github.com/skeeto/elfeed/)

The generated BiBTeX for web links can be directly inserted into a `.bib` file and handled by org-ref just like any other book/paper.
Alternatively (recommended), the BiBTeX can be kept in org-mode entries as the main bibliography source (and tangled into the .bib file if needed). An example of such setup can be found in [this blog post](http://cachestocaches.com/2020/3/org-mode-annotated-bibliography/).

The package also tries to make sure that no duplicate links are captured. If a duplicate is found, there is an option to display the location of the duplicate.

Below are examples of captured web links. The links are captured as todo-entries in org-mode with BiBTeX stored and code block within the entry.

![img](info-output.png)

Github page

![img](capture1.png)

    * TODO  yantar92 [Github] org-capture-ref: Extract bibtex info from captured websites :BOOKMARK:
    :PROPERTIES:
    :ID:       9c0d656603f59abfb5bec098b1a6aeea7c823c4b
    :CREATED:  [2020-08-24 Mon 21:21]
    :Source:   https://github.com/yantar92/org-capture-ref
    :END:
    :BIBTEX:
    #+begin_src bibtex
    @misc{9c0d656603f59abfb5bec098b1a6aeea7c823c4b,
      author =       {yantar92},
      howpublished = {Github},
      note =         {Online; accessed 24 August 2020},
      title =        {org-capture-ref: Extract bibtex info from captured
                      websites},
      url =          {https://github.com/yantar92/org-capture-ref},
    }
    #+end_src
    :END:

Reddit post

![img](capture2.png)

    * TODO  /u/drencomix [Reddit:Gentoo] (2020) Best Gentoo install video or blog tutorial to supplement the handbook? :BOOKMARK:
    :PROPERTIES:
    :ID: d6046a9b50b86abd6ff5957a554466074f0ed78e
    :CREATED: [2020-08-24 Mon 09:21]
    :Source: https://www.reddit.com/r/Gentoo/comments/if7aow/best_gentoo_install_video_or_blog_tutorial_to/
    :END:
    :BIBTEX:
    #+begin_src bibtex
    @misc{d6046a9b50b86abd6ff5957a554466074f0ed78e,
      author =       {/u/drencomix},
      howpublished = {Reddit:Gentoo},
      keywords =     {Gentoo},
      note =         {Online; accessed 24 August 2020},
      title =        {Best Gentoo install video or blog tutorial to
                      supplement the handbook?},
      url =
                      {https://www.reddit.com/r/Gentoo/comments/if7aow/best_gentoo_install_video_or_blog_tutorial_to/},
      year =         2020,
    }
    #+end_src
    :END:

Youtube link

![img](capture3.png)

    * TODO  Koncerthuset [Youtube] (2020) Those Ordinary Things // DR Big Band with Sinne Eeg (Live) :BOOKMARK:
    :PROPERTIES:
    :ID: e24aa466b27e06b30419d85f9fb17f891c965939
    :CREATED: [2020-08-24 Mon 09:24]
    :Source: https://www.youtube.com/watch?v=-P--Lh1YSw0
    :END:
    :BIBTEX:
    #+begin_src bibtex
    @misc{e24aa466b27e06b30419d85f9fb17f891c965939,
      author =       {DR Koncerthuset},
      howpublished = {Youtube},
      note =         {Online; accessed 24 August 2020},
      title =        {Those Ordinary Things // DR Big Band with Sinne Eeg
                      (Live)},
      url =          {https://www.youtube.com/watch?v=-P--Lh1YSw0},
      year =         2020,
    }
    #+end_src
    :END:

Blog post

![img](capture4.png)

    * TODO  jcs [Irreal] (2020) Irreal: Gccemacs on Linux :BOOKMARK:
    :PROPERTIES:
    :ID: b7a0973131c78328b117096045ee5c1d974e0eb0
    :CREATED: [2020-08-24 Mon 09:21]
    :Source: https://irreal.org/blog/?p=9094
    :END:
    :BIBTEX:
    #+begin_src bibtex
    @misc{b7a0973131c78328b117096045ee5c1d974e0eb0,
      author =       {jcs},
      howpublished = {Irreal},
      note =         {Online; accessed 24 August 2020},
      title =        {Irreal: Gccemacs on Linux},
      url =          {https://irreal.org/blog/?p=9094},
      year =         2020,
    }
    #+end_src
    :END:

Scientific article

![img](capture5.png)

    ****** TODO Brukner [Nature Physics] (2020) Facts are relative :BOOKMARK:
    :PROPERTIES:
    :ID: cd1ab39b6634e151b8ab0c6a56edf7d798f303dc
    :CREATED: [2020-08-20 Thu 21:31]
    :Source: https://doi.org/10.1038/s41567-020-0984-8
    :END:
    :LOGBOOK:
    - Refiled on [2020-08-21 Fri 07:00]
    :END:
    :BIBTEX:
    #+begin_src bibtex
    @article{cd1ab39b6634e151b8ab0c6a56edf7d798f303dc,
      author =       {Časlav Brukner},
      title =        {Facts are relative},
      journal =      {Nature Physics},
      year =         2020,
      doi =          {10.1038/s41567-020-0984-8},
      url =          {https://doi.org/10.1038/s41567-020-0984-8},
      howpublished = {Feeds.Nature},
      note =         {Online; accessed 20 August 2020},
    }
    #+end_src
    :END:


<a id="orgda78390"></a>

## Installation

The package is currently not on Melpa/Elpa now. It is possible to install package directly downloading the `.el` files from Github or using package managers with git support:


<a id="orga8d2a2a"></a>

### Using [straight.el](https://github.com/raxod502/straight.el/)

    (straight-use-package '(org-capture-ref :type git :host github :repo "yantar92/org-capture-ref"))

or with [use-package](https://github.com/jwiegley/use-package/)

    (use-package org-capture-ref
      :straight (org-capture-ref :type git :host github :repo "yantar92/org-capture-ref"))


<a id="org3bff520"></a>

### Using [quelpa](https://github.com/quelpa/quelpa)

    (quelpa '(org-capture-ref :repo "yantar92/org-capture-ref" :fetcher github))


<a id="orgc014900"></a>

### Using direct download

1.  Download `org-capture-ref.el` from this page and save it somewhere in Emacs [load-path](https://www.gnu.org/software/emacs/manual/html_node/emacs/Lisp-Libraries.html#Lisp-Libraries)
2.  Open the file in Emacs
3.  Run `M-x package-install-from-buffer <RET>`
4.  Put `(require 'org-capture-ref)` somewhere in your init file


<a id="orgefc6069"></a>

## Usage


<a id="orge7a2e55"></a>

### Capture setup

Below is example configuration defining org capture template using org-capture-ref, [asoc.el](https://github.com/troyp/asoc.el), [s.el](https://github.com/magnars/s.el) and [doct](https://github.com/progfolio/doct). You will need to install these packages to make the example work:

1.  Using [straight.el](https://github.com/raxod502/straight.el/)
    
        (straight-use-package '(asoc.el :type git :host github :repo "troyp/asoc.el"))
        (straight-use-package s)
        (straight-use-package doct)

2.  Using [straight.el](https://github.com/raxod502/straight.el/) with [use-package](https://github.com/jwiegley/use-package/)
    
        (use-package asoc
            :straight (asoc.el :type git :host github :repo "troyp/asoc.el"))
        (use-package s
          :straight t)
        (use-package doct
          :straight t)

3.  Using [quelpa](https://github.com/quelpa/quelpa)
    
        (quelpa '(asoc.el :repo "troyp/asoc.el" :fetcher github))
        (quelpa 's)
        (quelpa 'doct)

4.  Using direct download

Follow instructions from [Using direct download](#orgc014900). The packages can be downloaded from the following websites:

-   <https://github.com/troyp/asoc.el>
-   <https://github.com/magnars/s.el>
-   <https://github.com/progfolio/doct/>

The example will define two new capture templates:

-   **Silent link (B):** create a new TODO entry in `~/Org/inbox.org` containing author, journal/website, year, and title of the web-page + the generated BiBTeX (see examples above);
-   **Interactive link (b):** interactive version of the above. It opens Emacs frame allowing to modify the link before confirming the capture.

These capture templates can later be called from inside Emacs or from browser (using [org-protocol](https://orgmode.org/manual/The-capture-protocol.html#The-capture-protocol)).

    (require 'org-capture)
    (require 'asoc)
    (require 'doct)
    (require 'org-capture-ref)
    (let ((templates (doct '( :group "Browser link"
     			  :type entry
     			  :file "~/Org/inbox.org"
     			  :fetch-bibtex (lambda () (org-capture-ref-process-capture)) ; this must run first
    			  :bibtex (lambda () (org-capture-ref-get-bibtex-field :bibtex-string))
                              :url (lambda () (org-capture-ref-get-bibtex-field :url))
                              :type-tag (lambda () (org-capture-ref-get-bibtex-field :type))
    			  :title (lambda () (format "%s%s%s%s"
    					       (or (when (org-capture-ref-get-bibtex-field :author)
                                                         (let* ((authors (s-split " *and *" (org-capture-ref-get-bibtex-field :author)))
    							    (author-surnames (mapcar (lambda (author)
    										       (car (last (s-split " +" author))))
    										     authors)))
                                                           (unless (string= "article" (org-capture-ref-get-bibtex-field :type))
                                                             (setq author-surnames authors))
    						       (if (= 1 (length author-surnames))
                                                               (format "%s " (car author-surnames))
                                                             (format "%s, %s " (car author-surnames) (car (last author-surnames))))))
                                                       "")
                                                   (or (when (org-capture-ref-get-bibtex-field :journal)
    						     (format "[%s] " (org-capture-ref-get-bibtex-field :journal)))
                                                       (when (org-capture-ref-get-bibtex-field :howpublished)
                                                         (format "[%s] " (org-capture-ref-get-bibtex-field :howpublished)))
                                                       "")
                                                   (or (when (org-capture-ref-get-bibtex-field :year)
                                                         (format "(%s) " (org-capture-ref-get-bibtex-field :year)))
                                                       "")
                                                   (or (org-capture-ref-get-bibtex-field :title)
                                                       "")))
    			  :id (lambda () (org-capture-ref-get-bibtex-field :key))
                              :extra (lambda () (if (org-capture-ref-get-bibtex-field :journal)
    					   (s-join "\n"
    						   '("- [ ] download and attach pdf"
    						     "- [ ] check if bibtex entry has missing fields"
    						     "- [ ] read paper"
    						     "- [ ] check citing articles"
    						     "- [ ] check related articles"
    						     "- [ ] check references"))
                                             ""))
    			  :template
    			  ("%{fetch-bibtex}* TODO %? %{title} :BOOKMARK:%{type-tag}:"
    			   ":PROPERTIES:"
    			   ":ID: %{id}"
    			   ":CREATED: %U"
    			   ":Source: [[%{url}]]"
    			   ":END:"
                               ":BIBTEX:"
    			   "#+begin_src bibtex"
    			   "%{bibtex}"
    			   "#+end_src"
                               ":END:"
                               "%{extra}")
    			  :children (("Interactive link"
    				      :keys "b"
    				      :clock-in t
    				      :clock-resume t
    				      )
    				     ("Silent link"
    				      :keys "B"
    				      :immediate-finish t))))))
      (dolist (template templates)
        (asoc-put! org-capture-templates
    	       (car template)
    	       (cdr  template)
    	       'replace)))

**TL;DR how the above code works**: Call `org-capture-ref-process-capture` at the beginning to scrape BiBTeX from the link. Then use `org-capture-ref-get-bibtex-field` to get BiBTeX fields (`:bibtex-string` field will contain formatted BiBTeX entry).


<a id="org8f9ea41"></a>

### Capturing links from browser

The above capture templates can be used via  [org-protocol](https://orgmode.org/manual/The-capture-protocol.html#The-capture-protocol):

-   For popular browsers like Firefox, see [Alphapapa's org-protocol instructions](https://github.com/alphapapa/org-protocol-capture-html#org-protocol-instructions)
-   For Qutebrowser, see [Integration with qutebrowser](#qute_integration) section below.


<a id="org9eb50e8"></a>

### Capturing rss links from [elfeed](https://github.com/skeeto/elfeed/)

Example configuration for capturing `elfeed` entries (assuming the capture template above). `Elfeed` entry object is passed to org-capture-ref via `:elfeed-data`.

    (defun yant/elfeed-capture-entry ()
      "Capture selected entries into inbox."
      (interactive)
      (elfeed-search-tag-all 'opened)
      (previous-logical-line)
      (let ((entries (elfeed-search-selected)))
        (cl-loop for entry in entries
    	     do (elfeed-untag entry 'unread)
    	     when (elfeed-entry-link entry)
    	     do (flet ((raise-frame nil nil))
    		  (org-protocol-capture (list :template "B"
    					      :url it
    					      :title (format "%s: %s"
    							     (elfeed-feed-title (elfeed-entry-feed entry))
    							     (elfeed-entry-title entry))
                                                  :elfeed-data entry))))
        (mapc #'elfeed-search-update-entry entries)
        (unless (use-region-p) (forward-line))))

The above function should be ran (`M-x yant/elfeed-capture-entry <RET>`) with point at an `elfeed` entry.


<a id="org0c734a4"></a>

## Extra features


<a id="orgdc85d9c"></a>

### Detecting existing captures

Org-capture-ref checks if there are any existing headlines containing the captured link already. By default, :ID: {cite key of the BiBTeX} and :Source: {URL} properties of headlines are checked in all files searchable by `org-search-view`.

If org-capture-ref finds that the captured link already exist in org files the matching entry is shown by default unless capture template has `:immediate-finish t`.


<a id="qute_integration"></a>

### Integration with [qutebrowser](https://github.com/qutebrowser/qutebrowser/)

The web-page contents loaded in qutebrowser can be reused by org-capture-ref without a need to load the page again for parsing. This also means that content requiring authorisation can be parsed by the package.

If one wants to use this feature, extra argument `html` will need to be provided to org-protocol from qutebrowser userscript.

In addition, package logs can be shown as qutebrowser messages if `qutebrowser-fifo` is provided.

An example of bookmarking userscript is below:

    #!/bin/bash
    TEMPLATE="b"
    QUTE_URL=$(echo $QUTE_URL | sed -r 's/^[^/]+//')
    URL="$REPLY"
    TITLE="$(echo $QUTE_TITLE | sed -r 's/&//g')"
    SELECTED_TEXT="$QUTE_SELECTED_TEXT"
    (emacsclient "org-protocol://capture?template=$TEMPLATE&url=$URL&title=$TITLE&body=$SELECTED_TEXT&html=$QUTE_HTML&qutebrowser-fifo=$QUTE_FIFO"\
         && echo "message-info \"Bookmark saved to inbox.org/Inbox\"" >> "$QUTE_FIFO" || echo "message-error \"Bookmark not saved!\"" >> "$QUTE_FIFO");


<a id="org92f8b3d"></a>

## Customisation

The main function used in the package is `org-capture-ref-process-capture`. It takes the capture info from org-protocol, loads the link html (by default), and parses it to obtain and verify the BiBTeX. The parsing is done in the following steps:

1.  The capture info is scraped to get the necessary BiBTeX fields according to `org-capture-ref-get-bibtex-functions`
2.  Unique BiBTeX key is generated according to `org-capture-ref-generate-key-functions`
3.  The obtained BiBTeX fields and the key are used to format (`org-capture-ref-get-formatted-bibtex-functions`) and cleanup (`org-capture-ref-clean-bibtex-hook`) BiBTeX entry
4.  The generated entry is verified (by default, it is checked if the link is already present in org files) according to `org-capture-ref-check-bibtex-functions`


<a id="org092cba4"></a>

### Retrieving BiBTeX fields

When capture is done from `elfeed`, org-capture-ref first attempts to use the feed entry metadata to obtain all the necessary information. Otherwise, the BiBTeX information is retrieved by scraping the web-page (downloading it when necessary according to `org-capture-ref-get-buffer-functions`).

The necessary BiBTeX fields are the fields defined in `org-capture-ref-field-regexps`, though individual website parsers may add extra fields. For example, `elfeed` entries often contain keywords information.

Any captured link is assigned with `howpublished` field, which is simply web-site name without front `www` part and the tail `.com/org/...` part.

By default, the BiBTeX entry has `@misc` type (see `org-capture-ref-default-type`).

If capture information or website contains a DOI, <https://doi.org> is used to obtain the BiBTeX.

Parsers for the following websites are available:

-   Scientific articles from APS, Springer, Wiley, and Tandfonline publishers
-   Github repos
-   Youtube video pages
-   <https://habr.com> articles
-   Wechat articles
-   <https://author.today> books

Special parsers for the following RSS feeds are available (via `elfeed`):

-   <https://habr.com> articles
-   Reddit

**Contributions implementing additional parsers are welcome.**

If the above parsers did not scrape (or mark missing) all the fields from `org-capture-ref-field-regexps`, generic html parser is used to obtain them. This is often sufficient, but may not be accurate.

One can find information about writing own parsers in docstrings of `org-capture-ref-get-bibtex-functions` and `org-capture-ref-get-bibtex-from-elfeed-functions`.


<a id="org756f6b7"></a>

### Key generation

org-capture-ref relies on the fact the BiBTeX keys are unique for each entry and will remain unique if the same entry will be captured in future.

The key generation methods are defined in `org-capture-ref-generate-key-functions`. By default, sha1 hash of DOI (if present) or the URL are used as BiBTeX keys. The more readable built-in `bibtex-generate-autokey` is often not sufficient to generate unique keys since many link titles are too long and repetitive to be unique. **Though any contributions to generate human-readable BiBTeX keys are welcome.**


<a id="org2c11c38"></a>

### Formatting BiBTeX entry

By default, the BiBTeX entry is formatted according to `org-capture-ref-default-bibtex-template` with all the missing fields removed.
Then some common cleanups are applied to the entry (similar to org-ref, see `org-capture-ref-get-formatted-bibtex-functions`).

The behaviour can be customised by customising `org-capture-ref-get-formatted-bibtex-functions`.


<a id="orga99ff02"></a>

### Validating the BiBTeX entry

The common problem (at least, for me) of capturing the same links multiple times is avoided by verifying uniqueness of the captured entry. By default, the BiBTeX key, URL (as in generated BiBTeX), and the original link as passed to org-protocol are searched in org files. If a match is found, capture process is terminated, warning is shown, and the matching org entry is revealed.

It is assumed that the BiBTeX key is stored as org entry's :ID: property and the URL (org link URL) are stored as org entry's :Source: property.

The validation can be customised in `org-capture-ref-check-bibtex-functions`.

By default, search is done via `grep` (if installed). It can be switched to built-in `org-search-view` (for URL validation) and to `org-id-find` (for BiBTeX key validation) by customising `org-capture-ref-check-regexp-method` and `org-capture-ref-check-key-method`, respectively.


<a id="org4535dac"></a>

## Planned features

-   [X] Parsing amazon/goodreads for ISBN and generating BiBTeX using the obtained ISBN
-   [ ] Use DOM as main method to parse html
-   [ ] Automatically tangle the generated BiBTeX into .bib file (for org-ref integration)
-   [ ] Provide custom note function for org-ref

