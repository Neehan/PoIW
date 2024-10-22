# install conda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

# initialize conda
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh

# Ensure conda is initialized in the script
source ~/miniconda3/etc/profile.d/conda.sh

# clone repo
mkdir data data/llm_cache data/datasets

# create and activate the vllm environment, then install vllm
conda create --name vllm python=3.10 -y
conda init && conda activate vllm && pip install --upgrade vllm


echo "HF_HOME=~/PoIW/data/llm_cache/" > .env

wget -P data/datasets/ https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json
# python vllm_server/throughput_benchmark.py \
# --model neuralmagic/Meta-Llama-3.1-405B-Instruct-FP8 \
# --gpu-memory-utilization 0.95 \
# -tp 8 \
# --max-model-len 8192 \

# python vllm_server/throughput_benchmark.py \
# --model hugging-quants/Meta-Llama-3.1-405B-Instruct-AWQ-INT4 \
# --gpu-memory-utilization 0.72 \
# -tp 4 

sudo apt update
sudo apt install nginx
sudo mkdir /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt
cp vllm_server/nginx.text /etc/nginx/sites-available/default
service nginx restart

source ~/.bashrc
source ~/.zshrc


# # run server on port 9000, ngnix on port 8000 and forward traffic

# # server 
vllm serve neuralmagic/Meta-Llama-3.1-70B-Instruct-FP8 --host 127.0.0.1 --port 9000 --download-dir data/llm_cache/ --max-model-len 8192 --gpu-memory-utilization 0.97 --api-key kjghATDB6235SHDKUFbdnwu672jDGFHjkd27bdaYDNBF

# uvicorn main:app --host 127.0.0.1 --port 9001
# python -m vllm_server.server --host 127.0.0.1 --port 9000 --download-dir ~/data/llm_cache/ --model neuralmagic/Meta-Llama-3.1-8B-Instruct-FP8 --max-model-len 32000 --gpu-memory-utilization 0.97
