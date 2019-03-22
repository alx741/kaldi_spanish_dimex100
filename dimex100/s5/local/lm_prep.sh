#!/bin/bash

## Install SRILM in the `tools` directory (install_srilm.sh)

## Only run this file from the example root directory
##      $ ./local/data_prep.sh

if [ -d "../../../tools/srilm/bin/i686-m64" ]; then
    ngram_count_exe="../../../tools/srilm/bin/i686-m64/ngram-count"
elif [ -d "../../../tools/srilm/bin/i686" ]; then
    ngram_count_exe="../../../tools/srilm/bin/i686/ngram-count"
else
    echo
    echo "[!] Install SRILM in the 'tools' directory (install_srilm.sh)"
    echo
    exit 1
fi


##############
# data/lm_text
##############

# Text sentences input for language model generation
# taken from data/[train|test]/text but with utterance IDs removed

cat data/train/text data/test/text | cut -d' ' -f1 --complement > data/lm_text


