#!/bin/bash
set -e

# Install system dependencies
apt-get update
apt-get install -y ffmpeg python3 python3-pip python3-venv

# Create Python venv and install Whisper
python3 -m venv /opt/venv
export PATH="/opt/venv/bin:$PATH"
pip install openai-whisper

# Install Node dependencies
npm install
