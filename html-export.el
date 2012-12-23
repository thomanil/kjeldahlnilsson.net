(package-initialize)
(require 'org-publish)
(require 'htmlize)

(org-publish (quote
	      ("blog" :base-directory "~/versioncontrolled/public/kjeldahlnilsson.net/src/blog/"
	       :base-extension "org"
	       :publishing-directory "~/versioncontrolled/public/kjeldahlnilsson.net/tmp/"
	       :htmlized-source t
	       :recursive t
	       :table-of-contents nil
	       :html-preamble nil
	       :html-postamble nil
	       :section-numbers nil
	       :publishing-function org-publish-org-to-html
	       :headline-levels 3
	       :html-extension "html"
	       :body-only nil)) nil)
