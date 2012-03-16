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

.PHONY: media less coffee js

media:
	make less
	make coffee
	make js
	rm js/$(MAIN).js

less: $(LESS)/*.less
	$(BIN)/$(CLESS) $(LESS)/main.less | $(BIN)/$(CCSS) > $(CSS)/main.css
	$(BIN)/$(CLESS) $(LESS)/more.less | $(BIN)/$(CCSS) > $(CSS)/more.css

coffee: $(COFFEE)/*.coffee
	$(BIN)/$(CCOFFEE) $(COFFEE)/*.coffee > $(JS)/main.js

js: $(JS)/*.js
	$(BIN)/$(CJS) js/libs/* > js/$(LIB).min.js
	$(BIN)/$(CJS) js/$(MAIN).js > js/$(MAIN).min.js

clean:
	rm js/libs/$(MAIN).min.js -f
	rm css/* -f
