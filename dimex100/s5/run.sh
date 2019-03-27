#!/bin/bash

########
# Config
########

train_cmd="utils/run.pl"
decode_cmd="utils/run.pl"
CORPUS_DIR="CorpusDimex100"

N_HMM=2000 # leaves
N_GAUSSIANS=10000


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

steps/make_mfcc.sh --cmd "$train_cmd" "data/train" "exp/make_mfcc/train" mfcc
steps/make_mfcc.sh --cmd "$train_cmd" "data/test"  "exp/make_mfcc/test"  mfcc

steps/compute_cmvn_stats.sh "data/train" "exp/make_mfcc/train" mfcc
steps/compute_cmvn_stats.sh "data/test" "exp/make_mfcc/test" mfcc

utils/validate_data_dir.sh "data/train"
utils/validate_data_dir.sh "data/test"


#######################
# Lang data preparation
#######################

rm -rf data/local/dict
local/lang_prep.sh "$CORPUS_DIR"


############################
# Language model preparation
############################

local/lm_prep.sh
utils/prepare_lang.sh data/local/dict "<UNK>" data/local/lang data/lang


#######################
# Training and Decoding
#######################

utils/subset_data_dir.sh --first data/train 500 data/train_100

# Training and aligning
steps/train_mono.sh --cmd "$train_cmd" data/train_100 data/lang exp/mono || exit 1
# steps/align_si.sh --cmd "$train_cmd" data/train data/lang exp/mono exp/mono_aligned || exit 1
# steps/train_deltas.sh "$N_HMM" "$N_GAUSSIANS" data/train data/lang exp/mono_aligned exp/tri1 || exit 1
# steps/align_si.sh --cmd "$train_cmd" data/train data/lang exp/tri1 exp/tri1_aligned || exit 1

# Graph compilation
# utils/mkgraph.sh data/lang exp/tri1_aligned exp/tri1_aligned/graph_tgpr
# utils/mkgraph.sh data/lang exp/mono exp/mono/graph_tgpr
## this one for mono trainings
utils/mkgraph.sh --mono data/lang exp/mono exp/mono/graph_tgpr

# Decoding
# steps/decode.sh --cmd "$decode_cmd" exp/tri1_aligned/graph_tgpr data/test exp/tri1_aligned/decode_test
steps/decode.sh --cmd "$decode_cmd" exp/mono/graph_tgpr data/test exp/mono/decode_test

for x in exp/*/decode*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done
