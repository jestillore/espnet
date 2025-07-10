#!/usr/bin/env bash
set -eou pipefail

./asr.sh \
    --lang dari \
    --ngpu 8 \
    --stop_stage 13 \
    --asr_config conf/train_asr_transformer.yaml \
    --inference_config conf/decode_asr.yaml \
    --lm_config conf/train_lm.yaml \
    --train_set train \
    --valid_set valid \
    --test_sets test \
    --dumpdir /app/dumps \
    --expdir /app/experiments \
    --nbpe 2000 \
    --lm_train_text "data/train/text" "$@"
