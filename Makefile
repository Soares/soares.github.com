LESS = tools/lessc
CSS = tools/cleancss
COFFEE = tools/coffee -clp
JS = java -jar tools/closure.jar
COFFEES = $(addprefix coffee/, $(shell ls coffee))
LIBS = $(addprefix js/libs/, $(shell ls js/libs))
BASE_LESS = $(addprefix less/, $(shell ls less | grep -v -E "main"))

.PHONY: media clean

media:
	make css/more.css
	make css/main.css
	make js/lib.min.js
	make js/main.min.js

js/lib.min.js: $(LIBS)
	$(JS) $^ > js/lib.min.js

js/main.min.js: $(COFFEES)
	$(COFFEE) $^ | $(JS) > js/main.js

css/more.css: $(BASE_LESS)
	$(LESS) less/more.less | $(CSS) > css/more.css

css/main.css: css/more.css less/main.less
	$(LESS) less/main.less | $(CSS) > css/main.css

*.js:
*.css:
*.less:

clean:
	rm js/libs/main.min.js -f
	rm css/* -f
