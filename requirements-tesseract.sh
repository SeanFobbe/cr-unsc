# Install System Dependencies

apt-get install automake ca-certificates g++ git libtool libleptonica-dev make pkg-config

apt-get install --no-install-recommends asciidoc docbook-xsl xsltproc


# Clone Tesseract Repository

git clone  https://github.com/tesseract-ocr/tesseract.git --branch 5.3.0 --single-branch



# Compile from Source

cd tesseract
./autogen.sh
./configure
make
sudo make install
sudo ldconfig

