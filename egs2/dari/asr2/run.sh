#!/usr/bin/env bash
set -eou pipefail

./asr2.sh \
    --lang dari \
    --asr_config conf/train_asr_transformer.yaml \
    --inference_config conf/decode_asr.yaml \
    --lm_config conf/train_lm.yaml \
    --train_set train \
    --valid_set valid \
    --test_sets "valid test" \
    --lm_train_text "train/text" \
    --speed_perturb_factors "0.9 1.0 1.1" "$@"
