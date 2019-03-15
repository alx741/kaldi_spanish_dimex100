#!/bin/bash

mkdir -p data/train data/test data/local

N_SPEAKERS=100
N_COMMON_UTTERANCES=10
N_INDIVIDUAL_UTTERANCES=50
N_INDIVIDUAL_UTTERANCES_TRAINING=40
N_INDIVIDUAL_UTTERANCES_TESTING=10
CORPUS_DIR="$1"

DATA_DIR="../data"

##################
# /data/train/text
# /data/test/text
##################

# speakerId-utteranceId-[c|i]
#   c = speaker common utterances (10)
#   i = speaker individual utterances (50)
#
#   e.g.:
#       s001-01-c
#       ...
#       s001-10-c
#       ...
#       s001-01-i
#       ...
#       s001-50-i

## 80-20 train-test split
## Only individual utterances are used in testing
#    10/10 common utterances go into training
#    40/50 individual utterances go into training
#    10/50 individual utterances go into testing


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

function make_sentence_id
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

### Generate data/train/text
for i in $(seq 1 $N_SPEAKERS); do
    speaker_id=$(make_speaker_id $i)

    # Common utterances
    for j in $(seq 1 $N_COMMON_UTTERANCES); do
        sentence_id=$(make_sentence_id $j)
        utterance_id="$speaker_id-$sentence_id-c"
        trans_file="$CORPUS_DIR/$speaker_id/texto/comunes/$speaker_id$sentence_id.txt"
        if [ -f "$trans_file" ]; then
            transcription=$(cat "$trans_file")
            echo "$utterance_id $transcription" >> "$DATA_DIR/train/text"
        fi
    done

    # Individual utterances
    for k in $(seq 1 $N_INDIVIDUAL_UTTERANCES_TRAINING); do
        sentence_id=$(make_sentence_id $k)
        utterance_id="$speaker_id-$sentence_id-i"
        trans_file="$CORPUS_DIR/$speaker_id/texto/individuales/$speaker_id$sentence_id.txt"
        if [ -f "$trans_file" ]; then
            transcription=$(cat "$trans_file")
            echo "$utterance_id $transcription" >> "$DATA_DIR/train/text"
        fi
    done

done


### Generate data/test/text
for i in $(seq 1 $N_SPEAKERS); do
    speaker_id=$(make_speaker_id $i)

    # Individual utterances
    for k in $(seq $N_INDIVIDUAL_UTTERANCES_TRAINING $N_INDIVIDUAL_UTTERANCES); do
        sentence_id=$(make_sentence_id $k)
        utterance_id="$speaker_id-$sentence_id-i"
        trans_file="$CORPUS_DIR/$speaker_id/texto/individuales/$speaker_id$sentence_id.txt"
        if [ -f "$trans_file" ]; then
            transcription=$(cat "$trans_file")
            echo "$utterance_id $transcription" >> "$DATA_DIR/test/text"
        fi
    done

done
