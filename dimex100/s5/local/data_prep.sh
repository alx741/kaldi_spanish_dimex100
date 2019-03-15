#!/bin/bash

mkdir -p data/train data/test data/local

N_SPEAKERS=100

##################
# /data/train/text
# /data/test/text
##################

# speakerId-utteranceId-[c|i]
#   c = commun
#   i = individual

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

for i in $(seq 1 $N_SPEAKERS); do
    speaker_id=$(make_speaker_id $i)
    echo "$speaker_id"
done
