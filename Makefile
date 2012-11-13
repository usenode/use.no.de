SHELL=/bin/bash


./node_modules/.bin/proton:
	npm install

ghpages: ./node_modules/.bin/proton
	./node_modules/.bin/proton --port 9000 & echo "$$!" > use.no.de.pid; \
	sleep 1; \
	rm -fr ./dist; \
	mkdir -p ./dist; \
	find views -type d | \
		sed -e 's/views//' | \
		while read DIR; do \
			echo "./dist$$DIR" | xargs mkdir -p \
		; \
		done; \
	find views -type f | grep -v base.spv > files; \
	for FILE in `cat files`; do \
		STRIPPED=`echo "$$FILE" | sed -e 's/views//' -e 's/.pub//' -e 's/.spv//' -e 's/index//'`; \
		TARGET="./dist$$STRIPPED.html"; \
		if [ "x$$STRIPPED" = "x/" ]; then \
			TARGET="./dist/index.html"; \
		fi; \
		curl "http://127.0.0.1:9000$$STRIPPED" -o "$$TARGET"; \
		for REPLACE_FILE in `cat files | grep -v index.pub.spv`; do \
				REPLACE_FIND=`echo "$$REPLACE_FILE" | sed -e 's/views//' -e 's/.pub//' -e 's/.spv//'`; \
				REPLACE_WITH=`echo "$$REPLACE_FILE" | sed -e 's%views/%%' -e 's/.pub//' -e 's/.spv//'`; \
				sed -e "s%\"$$REPLACE_FIND\"%\"/$$REPLACE_WITH.html\"%" "$$TARGET" > /tmp/usenode-doc-generate; \
				mv /tmp/usenode-doc-generate "$$TARGET"; \
			done; \
	done; \
	cat ./use.no.de.pid | xargs kill -9; \
	rm use.no.de.pid files
