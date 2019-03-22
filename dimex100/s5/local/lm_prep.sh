#!/bin/bash

## Install SRILM in the `tools` directory (install_srilm.sh)

## Only run this file from the example root directory
##      $ ./local/data_prep.sh

OOV_SYMBOL="$1"

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


########################
# data/local/tmp/lm_text
########################

# Text sentences input for language model generation
# taken from data/[train|test]/text but with utterance IDs removed

cat data/train/text data/test/text | cut -d' ' -f1 --complement > data/local/tmp/lm_text


#################################
# data/local/tmp/3gram_arpa_lm.gz
##################################

$ngram_count_exe -lm data/local/tmp/3gram_arpa_lm.gz \
    -kndiscount1 -gt1min 0 -kndiscount2 -gt2min 2 \
    -kndiscount3 -gt3min 3 -order 3 \
    -unk -sort -map-unk "$OOV_SYMBOL" \
    -text data/local/tmp/lm_text
    # -vocab data/vocab # In case a custom vocabulary is available


######################
# data/local/tmp/G.txt
# data/lang/G.fst
######################

gunzip -c data/local/tmp/3gram_arpa_lm.gz \
    | arpa2fst --disambig-symbol=#0 --read-symbol-table=data/lang/words.txt - data/lang/G.fst

fstcompile --isymbols=data/lang/words.txt --osymbols=data/lang/words.txt \
  data/lang/tmpdir.g/select_empty.fst.txt \
  | fstarcsort --sort_type=olabel \
  | fstcompose - data/lang/G.fst > data/lang/tmpdir.g/empty_words.fst