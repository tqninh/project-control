# Sử dụng base image chính thức tối ưu cho vLLM và OpenAI-compatible API
FROM vllm/vllm-openai:latest

# Khai báo các biến môi trường mặc định (có thể ghi đè khi deploy hoặc chạy container)
ENV MODEL_NAME="Qwen/Qwen2.5-14B-Instruct-AWQ"
ENV QUANTIZATION="awq"
ENV MAX_MODEL_LEN="8192"
ENV PORT="8000"

# Expose cổng kết nối cho Cloud Run
EXPOSE 8000

# Lệnh khởi chạy vLLM server, hỗ trợ nhận token Hugging Face và tối ưu hóa VRAM trên GPU L4
ENTRYPOINT ["sh", "-c", "python3 -m vllm.entrypoints.openai.api_server \
    --model ${MODEL_NAME} \
    --port ${PORT} \
    --max-model-len ${MAX_MODEL_LEN} \
    --gpu-memory-utilization 0.92 \
    --trust-remote-code \
    ${QUANTIZATION:+--quantization $QUANTIZATION}"]
