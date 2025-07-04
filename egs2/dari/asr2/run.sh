#!/usr/bin/env bash
set -eou pipefail

./asr2.sh \
    --lang dari \
    --asr_config conf/train_asr_transformer.yaml \
    --inference_config conf/decode_asr.yaml \
    --lm_config conf/train_lm.yaml \
    --train_set data/train \
    --valid_set data/valid \
    --test_sets "data/valid data/test" \
    --lm_train_text "data/train/text" \
    --speed_perturb_factors "0.9 1.0 1.1" "$@"
