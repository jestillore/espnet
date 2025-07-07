#!/usr/bin/env bash
set -eou pipefail

# Generate spk2utt if missing
[ ! -f data/train/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
[ ! -f data/test/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt
[ ! -f data/valid/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/valid/utt2spk > data/valid/spk2utt

./asr.sh \
    --lang dari \
    --stage 2 \
    --stop_stage 13 \
    --asr_config conf/train_asr_transformer.yaml \
    --inference_config conf/decode_asr.yaml \
    --lm_config conf/train_lm.yaml \
    --train_set train \
    --valid_set valid \
    --test_sets "test" \
    --src_nbpe 3000 \
+   --tgt_nbpe 1500 \
    --lm_train_text "data/train/text" "$@"
