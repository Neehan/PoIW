# VLLM Inference Server with Auth Middleware
By default this middleware server is going to run on port 9001, then forward requests to port 9000 after
auth verification.

Use `\login` endpoint with `username` and `password` to generate JWT tokens. By default, the JWT tokens expire after 1 week. For every other request to vllm server, you must pass the JWT token in the authorization header.