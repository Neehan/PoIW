# Multiplyr LLM Inference Documentation - Version 0.1.0

## Overview
This documentation describes the available endpoints, methods, and responses for our FastAPI service.

### Base URL
`http://38.99.105.121:21126/`

## Endpoints

### Health Check
- **Endpoint:** `GET /health`
- **Description:** Checks the health of the service.
- **Responses:**
  - `200 OK`: Successful Response, returns a string indicating health status.

### Tokenize
- **Endpoint:** `POST /tokenize`
- **Description:** Tokenizes the provided text.
- **Request Body:**
  ```json
  {
    "model": "string",
    "prompt": "string",
    "add_special_tokens": true
  }
  ```
- **Responses:**
  - `200 OK`: Returns tokenized data as a string.
  - `422 Validation Error`: Errors in request data.

### Detokenize
- **Endpoint:** `POST /detokenize`
- **Description:** Converts tokens back to text.
- **Request Body:**
  ```json
  {
    "model": "string",
    "tokens": [0]
  }
  ```
- **Responses:**
  - `200 OK`: Successful Response, returns a string.
  - `422 Validation Error`: Errors in request data.

### Show Available Models
- **Endpoint:** `GET /v1/models`
- **Description:** Lists all available models.
- **Responses:**
  - `200 OK`: Returns a list of models as a string.

### Show Version
- **Endpoint:** `GET /version`
- **Description:** Shows the current version of the API.
- **Responses:**
  - `200 OK`: Successful Response, returns a string.

### Create Chat Completion
- **Endpoint:** `POST /v1/chat/completions`
- **Description:** Generates chat completions based on input.
- **Request Body:**
  ```json
  {
    "messages": [...],
    "model": "string",
    ...
  }
  ```
- **Responses:**
  - `200 OK`: Successful Response, returns generated text as a string.
  - `422 Validation Error`: Errors in request data.

### Create Completion
- **Endpoint:** `POST /v1/completions`
- **Description:** Generates completions for provided prompts.
- **Request Body:**
  ```json
  {
    "model": "string",
    "prompt": [0],
    ...
  }
  ```
- **Responses:**
  - `200 OK`: Successful Response, returns completions as a string.
  - `422 Validation Error`: Errors in request data.

### Create Embedding
- **Endpoint:** `POST /v1/embeddings`
- **Description:** Generates embeddings for given inputs.
- **Request Body:**
  ```json
  {
    "model": "string",
    "input": [0],
    ...
  }
  ```
- **Responses:**
  - `200 OK`: Successful Response, returns embeddings as a string.
  - `422 Validation Error`: Errors in request data.

```

This markdown format provides a clear and structured documentation that you can include in your GitBook. Each endpoint is detailed with methods, descriptions, request bodies, and expected responses.