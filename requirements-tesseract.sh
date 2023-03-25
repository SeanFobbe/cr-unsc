## Install System Dependencies

apt-get install automake ca-certificates g++ git libtool libleptonica-dev make pkg-config

apt-get install --no-install-recommends asciidoc docbook-xsl xsltproc


## Clone Tesseract Repository

git clone  https://github.com/tesseract-ocr/tesseract.git --branch 5.3.0 --single-branch



## Compile from Source

cd tesseract
./autogen.sh
./configure
make
sudo make install
sudo ldconfig



## Download Language Models

# English
wget -O ${TESSDATA_PREFIX}/eng.traineddata https://github.com/tesseract-ocr/tessdata_fast/blob/main/eng.traineddata

# Chinese
wget -O ${TESSDATA_PREFIX}/chi_sim.traineddata https://github.com/tesseract-ocr/tessdata_fast/blob/main/chi_sim.traineddata

# French
wget -O ${TESSDATA_PREFIX}/fra.traineddata https://github.com/tesseract-ocr/tessdata_fast/blob/main/fra.traineddata

# Spanish
wget -O ${TESSDATA_PREFIX}/spa.traineddata https://github.com/tesseract-ocr/tessdata_fast/blob/main/spa.traineddata

# Arabic
wget -O ${TESSDATA_PREFIX}/ara.traineddata https://github.com/tesseract-ocr/tessdata_fast/blob/main/ara.traineddata

# Russian
wget -O ${TESSDATA_PREFIX}/rus.traineddata https://github.com/tesseract-ocr/tessdata_fast/blob/main/rus.traineddata

# German
wget -O ${TESSDATA_PREFIX}/deu.traineddata https://github.com/tesseract-ocr/tessdata_fast/blob/main/deu.traineddata


