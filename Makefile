LESS = node_modules/less/bin/lessc --compress --O2
COFFEE = tools/coffee -clp
JS = java -jar tools/closure.jar
# Order matters
COFFEES = $(addprefix coffee/, $(addsuffix .coffee, ui dot glider more draw fractals main))
LIBS = $(addprefix js/libs/, $(shell ls js/libs))
BASE_LESS = $(addprefix less/, $(shell ls less | grep -vE "(main|more)"))

.PHONY: media less coffee devel clean

media:
	make js/lib.min.js
	make coffee
	make less

watch:
	$(COFFEE) -w coffee/* > js/main.min.js

less:
	make css/more.css
	make css/base.css
	make css/main.css

coffee:
	make js/main.min.js

js/lib.min.js: $(LIBS)
	$(JS) $^ > js/lib.min.js

js/main.min.js: $(COFFEES)
	$(COFFEE) $^ | $(JS) > js/main.min.js

css/more.css: $(BASE_LESS) less/more.less
	$(LESS) less/more.less > css/more.css

css/base.css: $(BASE_LESS)
	$(LESS) less/base.less > css/base.css

css/main.css: css/more.css less/main.less
	$(LESS) less/main.less > css/main.css

*.js:
*.css:
*.less:

clean:
	rm js/main.min.js -f
	rm js/lib.min.js -f
	rm css/* -f
