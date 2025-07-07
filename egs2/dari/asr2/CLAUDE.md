# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an ESPnet2 ASR (Automatic Speech Recognition) recipe for the Dari language. The repository implements a complete transformer-based ASR training and inference pipeline using the ESPnet framework.

## Key Commands

### Training Pipeline
```bash
# Run the complete ASR training pipeline
./run.sh

# Run specific stages (replace X-Y with stage numbers)
./run.sh --stage X --stop_stage Y

# Run with specific configuration
./run.sh --asr_config conf/train_asr_transformer.yaml --inference_config conf/decode_asr.yaml
```

### Direct ESPnet Commands
```bash
# ASR training
python -m espnet2.bin.mt_train --config conf/train_asr_transformer.yaml

# ASR inference
python -m espnet2.bin.mt_inference --mt_train_config exp/asr_train_*/config.yaml --mt_model_file exp/asr_train_*/valid.acc.best.pth

# Language model training
python -m espnet2.bin.lm_train --config conf/train_lm.yaml

# Perplexity calculation
python -m espnet2.bin.lm_calc_perplexity --model_file exp/lm_train_*/valid.loss.best.pth
```

### Environment Setup
```bash
# Source the environment
source path.sh

# Check Python environment
python --version
```

## Pipeline Architecture

The ASR pipeline consists of 17 stages organized into 5 main phases:

### 1. Data Preparation (Stages 1-7)
- **Stage 1**: Raw data preparation via `local/data.sh`
- **Stage 2**: Speed perturbation for data augmentation
- **Stage 3**: Audio format conversion and validation
- **Stage 4**: Filter audio segments by duration
- **Stage 5**: K-means clustering for SSL features
- **Stage 6**: Feature extraction
- **Stage 7**: BPE tokenization for source/target languages

### 2. Language Model Training (Stages 8-11)
- **Stage 8**: LM statistics collection
- **Stage 9**: LM training using RNN-based language model
- **Stage 10**: Perplexity calculation on test data
- **Stage 11**: N-gram LM training

### 3. ASR Training (Stages 12-13)
- **Stage 12**: ASR statistics collection
- **Stage 13**: Transformer ASR model training with multi-GPU support

### 4. Inference (Stage 14)
- Beam search decoding with CTC and attention weights
- Configurable via `conf/decode_asr.yaml`

### 5. Evaluation (Stage 15)
- SCLITE-based scoring for WER/CER calculation
- Generates detailed error analysis reports

## Key Configuration Files

- `conf/train_asr_transformer.yaml`: Main ASR training configuration
  - 12-layer transformer encoder, 6-layer decoder
  - 256-dim output, 4 attention heads
  - CTC weight: 0.3, Label smoothing: 0.1
  
- `conf/decode_asr.yaml`: Inference configuration
  - Beam size: 10, CTC weight: 0.3, LM weight: 0.1
  
- `conf/train_lm.yaml`: Language model training
  - 2-layer RNN LM with 650 units

## Directory Structure

```
├── run.sh              # Main execution script
├── asr2.sh            # ESPnet ASR recipe script (17 stages)
├── conf/              # Configuration files
│   ├── train_asr_transformer.yaml
│   ├── decode_asr.yaml
│   └── train_lm.yaml
├── local/             # Local data preparation scripts
│   └── data.sh        # Data preparation logic
├── path.sh            # Environment setup
└── exp/               # Experiment outputs (created during training)
```

## Key Parameters

### Training
- Language: Dari (`--lang dari`)
- Training set: `train` 
- Validation set: `valid`
- Test sets: `valid test`
- Speed perturbation: `0.9 1.0 1.1`
- Tokenization: BPE (30k vocabulary)

### Multi-GPU Training
- Configure `ngpu` parameter in `run.sh`
- Uses `espnet2.bin.launch` for distributed training
- Supports multi-node training via `num_nodes`

## Model Architecture

The ASR model uses a transformer-based encoder-decoder architecture:
- **Encoder**: 12-layer transformer with conv2d input layer
- **Decoder**: 6-layer transformer 
- **Training**: Joint CTC-attention training (CTC weight: 0.3)
- **Optimization**: Adam optimizer with warmup learning rate scheduling

## Data Requirements

The pipeline expects data in Kaldi format:
- `data/train/`: Training data (wav.scp, text, utt2spk)
- `data/valid/`: Validation data
- `data/test/`: Test data

The `run.sh` script automatically generates `spk2utt` files if missing.