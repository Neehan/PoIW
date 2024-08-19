# install conda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

# initialize conda
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh

# clone repo
mkdir data data/llm_cache data/datasets

# install vllm
conda create --name vllm python=3.10

conda activate vllm && pip install vllm==0.5.4
pip install --no-cache-dir -r requirements.txt

# echo "HF_HOME=~/PoIW/data/llm_cache/" > .env

source ~/.bashrc
source ~/.zshrc

# wget -P data/datasets/ https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json
# python vllm_server/throughput_benchmark.py \
# --model hugging-quants/Meta-Llama-3.1-405B-Instruct-AWQ-INT4 \
# --gpu-memory-utilization 0.97 \
# -tp 4 

sudo apt update
sudo apt install nginx
cp /nginx/nginx.conf /etc/nginx/nginx.conf:ro
cp /nginx/selfsigned.crt /etc/ssl/certs/selfsigned.crt:ro
cp /nginx/selfsigned.key /etc/ssl/private/selfsigned.key:ro
# mv vllm_server/nginx.text /etc/nginx/sites-available/default
service nginx restart

source ~/.bashrc


# run server on port 9000, ngnix on port 8000 and forward traffic

# server 
# python -m vllm_server.server --host 127.0.0.1 --port 9000 --download-dir data/llm_cache/ --model neuralmagic/Meta-Llama-3.1-70B-Instruct-FP8 --max-model-len 32000 --gpu-memory-utilization 0.97

uvicorn main:app --host 127.0.0.1 --port 9001
python -m vllm_server.server --host 127.0.0.1 --port 9000 --download-dir ~/data/llm_cache/ --model neuralmagic/Meta-Llama-3.1-8B-Instruct-FP8 --max-model-len 32000 --gpu-memory-utilization 0.97
