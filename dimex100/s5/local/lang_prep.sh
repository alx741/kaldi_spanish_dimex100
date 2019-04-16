#!/bin/bash

## Only run this file from the example root directory
##      $ ./local/data_prep.sh

CORPUS_DIR="$1"

mkdir -p "data/local/dict"

source ./path.sh

#############################
# data/local/dict/lexicon.txt
#############################

echo -e '!SIL sil\n<UNK> spn' > data/local/dict/lexicon.txt
cat "$CORPUS_DIR/diccionarios/T22.full.dic" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -e 's/([0123456789]*)//g' \
        -e 's/[^ ]n\~/ñ/g' \
        -e 's/a_7/á/g' -e 's/e_7/é/g' -e 's/i_7/í/g' -e 's/o_7/ó/g' -e 's/u_7/ú/g' \
        -e 's/a-7/á/g' -e 's/e-7/é/g' -e 's/i-7/í/g' -e 's/o-7/ó/g' -e 's/u-7/ú/g' \
        -e 's/a_/á/g' -e 's/e_/é/g' -e 's/i_/í/g' -e 's/o_/ó/g' -e 's/u_/ú/g' \
    | sed -e 's/_7n.*$//' \
        -e 's/atl_7tica/atlética/' \
        -e 's/biol_7gicas/biológicas/' \
        -e 's/elec_7ctrico/eléctrico/' \
        -e 's/gr_7afico/gráfico/' \
        -e 's/s_7lo/sólo/' \
    | uniq \
    >> data/local/dict/lexicon.txt


#######################################
# data/local/dict/silence_phones.txt
# data/local/dict/optional_silence.txt
# data/local/dict/nonsilence_phones.txt
# data/local/dict/extra_questions.txt
#######################################

echo -e 'sil\nspn' > data/local/dict/silence_phones.txt
echo -e 'sil' > data/local/dict/optional_silence.txt
cat data/local/dict/lexicon.txt \
    | grep -v '<UNK>' \
    | grep -v '!SIL' \
    | tr '\t' ' ' \
    | cut -d' ' -f1 --complement \
    | sed 's/ /\n/g' \
    | sort -u \
    | tr '[:upper:]' '[:lower:]' \
    > data/local/dict/nonsilence_phones.txt
