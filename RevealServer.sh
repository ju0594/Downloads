#!/bin/sh

# Create Directory
mkdir -p Reveal && cd Reveal

# Download latest Reveal.zip
wget -nv https://dl.devmate.com/com.ittybittyapps.Reveal2/Reveal.zip -O Reveal.zip

# Extract
unzip Reveal.zip && rm Reveal.zip

# Copy RevealServer.zip
cp Reveal.app/Contents/SharedSupport/RevealServer.zip . && rm -rf Reveal.app

# Exit
cd ..
