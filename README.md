# Kaldi ASR example using the Spanish DIMEx100 corpus

1. Move the `dimex100` directory into Kaldi's `egs` directory
2. Make symbolic links for `steps` and `utils`

    $ cd kaldi/egs/dimex100/s5
    $ ln -s ../../wsj/s5/steps steps
    $ ln -s ../../wsj/s5/utils utils

3. Run `run.sh`


# Results

`time ./run.sh` tail output:

````
Decoding

steps/decode.sh --config conf/decode.config --cmd utils/run.pl exp/tri2b/graph data/test exp/tri2b_mmi_b0.05/decode_test
decode.sh: feature type is lda
steps/diagnostic/analyze_lats.sh --cmd utils/run.pl exp/tri2b/graph exp/tri2b_mmi_b0.05/decode_test
steps/diagnostic/analyze_lats.sh: see stats in exp/tri2b_mmi_b0.05/decode_test/log/analyze_alignments.log
Overall, lattice depth (10,50,90-percentile)=(1,1,3) and mean=2.7
steps/diagnostic/analyze_lats.sh: see stats in exp/tri2b_mmi_b0.05/decode_test/log/analyze_lattice_depth_stats.log
exp/tri2b_mmi_b0.05/decode_test/wer_10
%WER 7.68 [ 73 / 950, 52 ins, 0 del, 21 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_11
%WER 8.11 [ 77 / 950, 55 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_12
%WER 8.11 [ 77 / 950, 55 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_13
%WER 8.11 [ 77 / 950, 55 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_14
%WER 8.11 [ 77 / 950, 55 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_15
%WER 8.11 [ 77 / 950, 55 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_16
%WER 7.89 [ 75 / 950, 53 ins, 0 del, 22 sub ]
%SER 9.18 [ 9 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_17
%WER 8.00 [ 76 / 950, 54 ins, 0 del, 22 sub ]
%SER 9.18 [ 9 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_7
%WER 8.95 [ 85 / 950, 63 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_8
%WER 8.84 [ 84 / 950, 62 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
exp/tri2b_mmi_b0.05/decode_test/wer_9
%WER 8.21 [ 78 / 950, 56 ins, 0 del, 22 sub ]
%SER 10.20 [ 10 / 98 ]
%WER 7.68 [ 73 / 950, 52 ins, 0 del, 21 sub ] exp/tri2b_mmi_b0.05/decode_test/wer_10
real 3752.49
user 8839.58
sys 393.39
```
