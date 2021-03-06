.PHONY:	clean clean-html all check deploy debug

XSLTPROC = xsltproc --timing --stringparam debug.datedfiles no --stringparam html.google-classic UA-48250536-1 # -v

docs:	docs/parity.pdf parity-pretty.xml parity.xsl filter.xsl
	mkdir -p docs
	cd docs/; \
	$(XSLTPROC) ../parity.xsl ../parity-pretty.xml

parity.tex:	parity-pretty.xml parity-latex.xsl filter.xsl
	$(XSLTPROC) -o parity.tex parity-latex.xsl parity-pretty.xml

docs/parity.pdf:	parity.tex
	mkdir -p docs
	cd docs && latexmk -pdf -shell-escape -pdflatex="pdflatex -shell-escape -interaction=nonstopmode"  ../parity.tex

docs/images/:	docs parity-wrapper.xml
	mkdir -p docs/images
	../mathbook/script/mbx -vv -c latex-image -f svg -d ~/parity/docs/images ~/parity/parity-wrapper.xml

parity-wrapper.xml:	*.pug pug-plugin.json
	pug -O pug-plugin.json --extension xml parity-wrapper.pug
	sed -i.bak -e 's/proofcase/case/g' parity-wrapper.xml # Fix proofcase->case !! UGLY HACK, SAD
	rm parity-wrapper.xml.bak

parity-pretty.xml: parity-wrapper.xml
	xmllint --pretty 2 parity-wrapper.xml > parity-pretty.xml

all:	docs docs/parity.pdf

deploy: clean-html parity-wrapper.xml docs
	cp parity-wrapper.xml docs/parity.xml
	./deploy.sh

debug:	*.pug pug-plugin.json
	pug -O pug-plugin.json --pretty --extension xml parity-wrapper.pug

check:	parity-pretty.xml
	jing ../mathbook/schema/pretext.rng parity-pretty.xml
	#xmllint --xinclude --postvalid --noout --dtdvalid ../mathbook/schema/dtd/mathbook.dtd parity-pretty.xml
	$(XSLTPROC) ../mathbook/schema/pretext-schematron.xsl parity-pretty.xml

clean-html:
	rm -rf docs

clean:	clean-html
	rm -f parity.md
	rm -f parity*.tex
	rm -f parity*.xml
