#!/bin/sh

jobdir=$(realpath `dirname $0`)
jobname=${jobdir##*/}

cd "$jobdir"


# convert figures with inkscape
if [[ "$fig" != "" ]]; then
    cd fig

    for file in *.svg; do
        echo "Processing $file..."
        sed -i 's/#000000/#ffffff/g' $file
        inkscape --without-gui --export-area-drawing --export-pdf="${file%svg}pdf" -f "$file"
    done

    cd ..
fi

export TEXINPUTS=.:./tex:../common/tex:$TEXINPUTS
xelatex -jobname="$jobname" -halt-on-error -output-directory=out/ ./tex/main.tex
