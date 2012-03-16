LESS = tools/lessc
CSS = tools/cleancss
COFFEE = tools/coffee -clp
JS = tools/compressJS.sh

.PHONY: media clean

media:
	make css/more.css
	make css/main.css
	make js/lib.min.js
	make js/main.min.js

js/main.js: coffee/dot.coffee coffee/draw.coffee coffee/fractals.coffee coffee/glider.coffee coffee/glider.coffee coffee/main.coffee coffee/ui.coffee
	$(COFFEE) $^ > js/main.js

js/lib.min.js: js/libs/bootstrap-button.js js/libs/color.min.js js/libs/underscore-1.3.1.min.js
	$(JS) $^ > js/lib.min.js

js/main.min.js: js/main.js
	$(JS) js/main.js > js/main.min.js

css/more.css: less/base.less less/btn.less less/helpers.less less/icons.less less/normalize.less less/print.less
	$(LESS) less/more.less | $(CSS) > css/more.css

css/main.css: css/more.css less/main.less
	$(LESS) less/main.less | $(CSS) > css/main.css

*.css:

clean:
	rm js/libs/main.min.js -f
	rm css/* -f
