CLESS = lessc
CCSS = cleancss
CCOFFEE = coffee -clp
CJS = compressJS.sh
LESS = less
COFFEE = coffee
CSS = css
JS = js
BIN = tools
LIB = lib
MAIN = main

.PHONY: media less

media:
	make less
	make coffee
	make $(JS)/$(LIB).min.js
	make $(JS)/$(MAIN).min.js
	rm js/$(MAIN).js

less: $(LESS)/*.less
	$(BIN)/$(CLESS) $(LESS)/main.less | $(BIN)/$(CCSS) > $(CSS)/main.css
	$(BIN)/$(CLESS) $(LESS)/more.less | $(BIN)/$(CCSS) > $(CSS)/more.css

$(JS)/$(MAIN).js:
	$(BIN)/$(CCOFFEE) $(COFFEE)/*.coffee > $(JS)/main.js

$(JS)/$(LIB).min.js:
	$(BIN)/$(CJS) js/libs/* > js/$(LIB).min.js

$(JS)/$(MAIN).min.js: $(JS)/$(MAIN).js
	$(BIN)/$(CJS) js/$(MAIN).js > js/$(MAIN).min.js

clean:
	rm js/libs/$(MAIN).min.js -f
	rm css/* -f
