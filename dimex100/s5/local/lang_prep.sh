#!/bin/bash

## Only run this file from the example root directory
##      $ ./local/data_prep.sh

CORPUS_DIR="$1"
OOV_SYMBOL="$2"

mkdir -p "data/local/dict"

#############################
# data/local/dict/lexicon.txt
#############################

echo "$OOV_SYMBOL $OOV_SYMBOL" > data/local/dict/lexicon.txt
cat "$CORPUS_DIR/diccionarios/T22.full.dic" >> data/local/dict/lexicon.txt


#######################################
# data/local/dict/silence_phones.txt
# data/local/dict/optional_silence.txt
# data/local/dict/nonsilence_phones.txt
# data/local/dict/extra_questions.txt
#######################################

echo -e "SIL" > data/local/dict/silence_phones.txt
echo "SIL" > data/local/dict/optional_silence.txt
cat data/local/dict/lexicon.txt \
    | tr '\t' ' ' \
    | cut -d' ' -f1 --complement \
    | sed 's/ /\n/g' \
    | sort -u \
    > data/local/dict/nonsilence_phones.txt


##############
# Prepare lang
##############

utils/prepare_lang.sh data/local/dict "$OOV_SYMBOL" data/local/lang data/lang
