## Install System Dependencies

apt-get install -y wget automake ca-certificates g++ git libtool libleptonica-dev make pkg-config

apt-get install -y --no-install-recommends asciidoc docbook-xsl xsltproc


## Clone Tesseract Repository

git clone  https://github.com/tesseract-ocr/tesseract.git --branch 5.3.0 --single-branch



## Compile from Source

cd tesseract
./autogen.sh
./configure
make
make install
ldconfig


## Download Language Models


# Arabic
wget -O /usr/local/share/tessdata/ara.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/ara.traineddata

# Chinese
wget -O /usr/local/share/tessdata/chi_sim.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/chi_sim.traineddata

# English
wget -O /usr/local/share/tessdata/eng.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/eng.traineddata

# French
wget -O /usr/local/share/tessdata/fra.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/fra.traineddata

# German
wget -O /usr/local/share/tessdata/deu.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/deu.traineddata

# Russian
wget -O /usr/local/share/tessdata/rus.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/rus.traineddata

# Spanish
wget -O /usr/local/share/tessdata/spa.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/main/spa.traineddata
