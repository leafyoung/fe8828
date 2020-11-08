all: p1 p2 p3 p4 p6

.PHONY : clean
clean:
	-rm *.aux *.log

p1: lec01.pdf lecW1x2.tex
	pdflatex lecW1x2.tex
	-rm *.aux *.log

p2: lec04.pdf lecW2x2.tex
	pdflatex lecW2x2.tex
	-rm *.aux *.log

p3: lec07.pdf lecW3x2.tex
	pdflatex lecW3x2.tex
	-rm *.aux *.log

p4: lec10.pdf lecW4x2.tex
	pdflatex lecW4x2.tex
	move lecW4x2.pdf FE8828-lecW4x2.pdf
	-rm *.aux *.log

p5: lec13.pdf lecW5x2.tex
	pdflatex lecW5x2.tex
	move lecW5x2.pdf FE8828-lecW5x2.pdf
	-rm *.aux *.log

# p5: A4 format

p6: lecW6.pdf lecW6x2.tex
	pdflatex lecW6x2.tex
	-rm *.aux *.log
