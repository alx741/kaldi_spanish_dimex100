#!/bin/bash

N_SPEAKERS=100
N_COMMON_UTTERANCES=10
N_INDIVIDUAL_UTTERANCES=50
N_INDIVIDUAL_UTTERANCES_TRAINING=40
N_INDIVIDUAL_UTTERANCES_TESTING=10
CORPUS_DIR="$1"
DATA_DIR="$2"

rm -rfv "$DATA_DIR"
mkdir -p "$DATA_DIR/train" "$DATA_DIR/test" "$DATA_DIR/local"

#################
# data/train/text
# data/test/text
#################

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
    printf "s%03d" "$1"
}

function make_sentence_id
{
    printf "%02d" "$1"
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




####################
# data/train/wav.scp
# data/test/wav.scp
####################


### Generate data/train/wav.scp
for i in $(seq 1 $N_SPEAKERS); do
    speaker_id=$(make_speaker_id $i)

    # Common utterances
    for j in $(seq 1 $N_COMMON_UTTERANCES); do
        sentence_id=$(make_sentence_id $j)
        utterance_id="$speaker_id-$sentence_id-c"
        wav_file="$CORPUS_DIR/$speaker_id/audio_editado/comunes/$speaker_id$sentence_id.wav"
        if [ -f "$wav_file" ]; then
            echo "$utterance_id $wav_file" >> "$DATA_DIR/train/wav.scp"
        fi
    done

    # Individual utterances
    for k in $(seq 1 $N_INDIVIDUAL_UTTERANCES_TRAINING); do
        sentence_id=$(make_sentence_id $k)
        utterance_id="$speaker_id-$sentence_id-i"
        wav_file="$CORPUS_DIR/$speaker_id/audio_editado/individuales/$speaker_id$sentence_id.wav"
        if [ -f "$wav_file" ]; then
            echo "$utterance_id $wav_file" >> "$DATA_DIR/train/wav.scp"
        fi
    done

done


### Generate data/test/wav.scp
for i in $(seq 1 $N_SPEAKERS); do
    speaker_id=$(make_speaker_id $i)

    # Individual utterances
    for k in $(seq $N_INDIVIDUAL_UTTERANCES_TRAINING $N_INDIVIDUAL_UTTERANCES); do
        sentence_id=$(make_sentence_id $k)
        utterance_id="$speaker_id-$sentence_id-i"
        wav_file="$CORPUS_DIR/$speaker_id/audio_editado/individuales/$speaker_id$sentence_id.wav"
        if [ -f "$wav_file" ]; then
            echo "$utterance_id $wav_file" >> "$DATA_DIR/test/wav.scp"
        fi
    done

done
