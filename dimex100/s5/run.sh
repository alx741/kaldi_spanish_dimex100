#!/bin/bash

########
# Config
########

train_cmd="utils/run.pl"
decode_cmd="utils/run.pl"
CORPUS_DIR="CorpusDimex100"
OOV_SYMBOL="<unk>"


#################
# Download corpus
#################

if [ ! -d "$CORPUS_DIR" ]; then
  wget http://turing.iimas.unam.mx/~luis/DIME/DIMEx100/DVD/DVDCorpusDimex100.zip || exit 1;
  unzip DVDCorpusDimex100.zip || exit 1;
fi


##################
# Data preparation
##################

rm -rf data exp mfcc
local/data_prep.sh "$CORPUS_DIR"
utils/fix_data_dir.sh "data/train"
utils/fix_data_dir.sh "data/test"


#####################
# Features generation
#####################

steps/make_mfcc.sh --nj 20 --cmd "$train_cmd" "data/train" "exp/make_mfcc/train" mfcc
steps/make_mfcc.sh --nj 20 --cmd "$train_cmd" "data/test"  "exp/make_mfcc/test"  mfcc

steps/compute_cmvn_stats.sh "data/train" "exp/make_mfcc/train" mfcc
steps/compute_cmvn_stats.sh "data/test" "exp/make_mfcc/test" mfcc

utils/validate_data_dir.sh "data/train"
utils/validate_data_dir.sh "data/test"


#######################
# Lang data preparation
#######################

local/lang_prep.sh "$CORPUS_DIR" "$OOV_SYMBOL"
