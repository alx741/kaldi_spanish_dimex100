#!/bin/bash

mkdir -p data/train data/test data/local

N_SPEAKERS=100
N_COMMON_UTTERANCES=10
N_INDIVIDUAL_UTTERANCES=50

##################
# /data/train/text
# /data/test/text
##################

# speakerId-utteranceId-[c|i]
#   c = speaker common utterances (10)
#   i = speaker individual utterances (50)

## 80-20 train-test split
## Only individual utterances are used in testing
#    10/10 common utterances go into training
#    40/50 individual utterances go into training
#    10/50 individual utterances go into testing

# s001-01-c
# ...
# s001-10-c

# s001-01-i
# ...
# s001-50-i

function make_speaker_id
{
    index="$1"
    digits="${#index}"
    case $digits in
        '1')
            echo "s00$index"
            ;;
        '2')
            echo "s0$index"
            ;;
        '3')
            echo "s$index"
            ;;
    esac
}

function make_utterance_id
{
    index="$1"
    digits="${#index}"
    case $digits in
        '1')
            echo "0$index"
            ;;
        '2')
            echo "$index"
            ;;
    esac
}

for i in $(seq 1 $N_SPEAKERS); do
    speaker_id=$(make_speaker_id $i)
    echo "$speaker_id"
done
