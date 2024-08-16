# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Install the necessary Python packages
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY app/ /app

# Make port 9001 available to the world outside this container
EXPOSE 9001

# Run the FastAPI server using Uvicorn
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9001"]

# command to generate the certificate
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#   -keyout nginx/selfsigned.key \
#   -out nginx/selfsigned.crt \
#   -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"