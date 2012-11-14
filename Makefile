SHELL=/bin/bash


./node_modules/.bin/proton:
	npm install

ghpages: ./node_modules/.bin/proton
	@ GHPAGES_CLONE="../usenode.github.com-update"; \
	if [ -d "$$GHPAGES_CLONE" ]; then \
		echo "Error: remove $$GHPAGES_CLONE directory"; \
		exit 1; \
	fi; \
	git clone git@github.com:usenode/usenode.github.com.git "$$GHPAGES_CLONE" --branch gh-pages; \
	./node_modules/.bin/proton --port 9000 & echo "$$!" > use.no.de.pid; \
	sleep 1; \
	find views -type d | \
		sed -e 's/views//' | \
		while read DIR; do \
			echo "$$GHPAGES_CLONE$$DIR" | xargs mkdir -p \
		; \
		done; \
	find views -type f | grep -v base.spv > files; \
	for FILE in `cat files`; do \
		STRIPPED=`echo "$$FILE" | sed -e 's/views//' -e 's/.pub//' -e 's/.spv//' -e 's/index//'`; \
		TARGET="$$GHPAGES_CLONE$$STRIPPED.html"; \
		if [ "x$$STRIPPED" = "x/" ]; then \
			TARGET="$$GHPAGES_CLONE/index.html"; \
		fi; \
		echo "Generating $$STRIPPED"; \
		curl --progress-bar "http://127.0.0.1:9000$$STRIPPED" -o "$$TARGET"; \
		for REPLACE_FILE in `cat files | grep -v index.pub.spv`; do \
				REPLACE_FIND=`echo "$$REPLACE_FILE" | sed -e 's/views//' -e 's/.pub//' -e 's/.spv//'`; \
				REPLACE_WITH=`echo "$$REPLACE_FILE" | sed -e 's%views/%%' -e 's/.pub//' -e 's/.spv//'`; \
				sed -e "s%\"$$REPLACE_FIND\"%\"/$$REPLACE_WITH.html\"%" "$$TARGET" > /tmp/usenode-doc-generate; \
				mv /tmp/usenode-doc-generate "$$TARGET"; \
			done; \
	done; \
	cat ./use.no.de.pid | xargs kill -9; \
	rm use.no.de.pid files; \
	cp -R static/* "$$GHPAGES_CLONE"; \
	(cd "$$GHPAGES_CLONE" && git add --all && git ci -m "Updating with generated documentation" && git push origin gh-pages); \
	rm -fr "$$GHPAGES_CLONE"
