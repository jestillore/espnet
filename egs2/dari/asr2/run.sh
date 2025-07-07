#!/usr/bin/env bash
set -eou pipefail

# Generate spk2utt if missing
[ ! -f data/train/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
[ ! -f data/test/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt
[ ! -f data/valid/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/valid/utt2spk > data/valid/spk2utt

./asr2.sh \
    --lang dari \
    --asr_config conf/train_asr_transformer.yaml \
    --inference_config conf/decode_asr.yaml \
    --lm_config conf/train_lm.yaml \
    --train_set train \
    --valid_set valid \
    --test_sets "valid test" \
    --lm_train_text "data/train/text" \
    --speed_perturb_factors "0.9 1.0 1.1" "$@"
