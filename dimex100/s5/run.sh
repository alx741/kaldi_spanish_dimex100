#!/bin/bash

train_cmd="utils/run.pl"
decode_cmd="utils/run.pl"

CORPUS_DIR="CorpusDimex100"


#################
# Download corpus
#################

if [ ! -d "$CORPUS_DIR" ]; then
  wget http://turing.iimas.unam.mx/~luis/DIME/DIMEx100/DVD/DVDCorpusDimex100.zip || exit 1;
  unzip DVDCorpusDimex100.zip || exit 1;
fi
