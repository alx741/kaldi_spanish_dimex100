#!/bin/bash

## Only run this file from the example root directory
##      $ ./local/data_prep.sh

CORPUS_DIR="$1"
OOV_SYMBOL="$2"

mkdir -p "data/local/dict"

#############################
# data/local/dict/lexicon.txt
#############################

cp "$CORPUS_DIR/diccionarios/T22.full.dic" data/local/dict/lexicon.txt


#######################################
# data/local/dict/silence_phones.txt
# data/local/dict/nonsilence_phones.txt
# data/local/dict/extra_questions.txt
#######################################

# Use the Mexbet phones alphabet
# http://turing.iimas.unam.mx/~luis/DIME/DIMEx100/manualdimex100/mexbet.html

touch data/local/dict/silence_phones.txt
touch data/local/dict/extra_questions.txt
cat data/local/dict/lexicon.txt \
    | tr '\t' ' ' \
    | cut -d' ' -f1 --complement \
    | sed 's/ / /g' \
    | sort -u \
    > data/local/dict/nonsilence_phones.txt


##############
# Prepare lang
##############

utils/prepare_lang.sh data/local/dict "$OOV_SYMBOL" data/local/lang data/lang
