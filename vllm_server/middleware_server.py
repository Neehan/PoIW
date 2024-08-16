from fastapi import FastAPI, Request, HTTPException, Depends
from fastapi_jwt_auth import AuthJWT
from fastapi_jwt_auth.exceptions import AuthJWTException
from pydantic import BaseSettings
import requests
from fastapi.responses import Response
import os
import dotenv
from pydantic import BaseModel, Field  # , validator

dotenv.load_dotenv()


# Example Pydantic model for login input
class LoginRequest(BaseModel):
    username: str = Field(..., min_length=3, max_length=32, regex=r"^[a-zA-Z0-9@.]+$")
    password: str = Field(
        ..., min_length=8, max_length=32, regex=r"^[a-zA-Z0-9!@#$%^&*.]+$"
    )


# App instance
app = FastAPI()


# Config for JWT using pydantic BaseSettings for environment variables
class Settings(BaseSettings):
    # authjwt_secret_key: str = os.environ.get("JWT_API_KEY")
    authjwt_secret_key: str = "secret"

    class Config:
        env_file = ".env"


@AuthJWT.load_config
def get_config():
    return Settings()


# JWT Exception handler
@app.exception_handler(AuthJWTException)
def authjwt_exception_handler(request: Request, exc: AuthJWTException):
    return Response(content=exc.message, status_code=exc.status_code)


# Middleware to handle JWT authentication and forward the request
@app.middleware("http")
async def auth_middleware(request: Request, call_next):
    try:
        if request.url.path == "/login" or "/":
            return await call_next(request)

        # Get the JWT token from headers
        token = request.headers.get("Authorization")
        if not token:
            return Response(status_code=401, content="Missing JWT token")

        # Validate the JWT
        Authorize = AuthJWT()
        Authorize.jwt_required()

        # Forward the request to the backend server
        url = f"http://127.0.0.1:{os.environ.get('VLLM_PORT')}{request.url.path}"
        headers = dict(request.headers)
        body = await request.body()

        response = requests.request(
            method=request.method,
            url=url,
            headers=headers,
            data=body,
            params=request.query_params,
            allow_redirects=False,
        )

        return Response(
            content=response.content,
            status_code=response.status_code,
            headers=dict(response.headers),
        )

    except AuthJWTException as auth_error:
        return Response(
            content=str(auth_error.message), status_code=auth_error.status_code
        )

    except Exception as e:
        # Print the stack trace for debugging purposes
        print(e)
        return Response(content="Internal Server Error", status_code=500)


@app.post("/login")
def login(login_data: LoginRequest, Authorize: AuthJWT = Depends()):
    if login_data.username != os.environ.get(
        "ADMIN_USERNAME"
    ) or login_data.password != os.environ.get("ADMIN_PASSWORD"):
        raise HTTPException(status_code=401, detail="Unauthorized!")

    # Create JWT tokens with expiration
    access_token = Authorize.create_access_token(
        subject=login_data.username, expires_time=3600 * 24 * 7
    )  # 7 day expiration
    return {"access_token": access_token}


@app.get("/")
def root(Authorize: AuthJWT = Depends()):
    Authorize.jwt_optional()
    return {"message": "Welcome to Multiplyr LLM Service API!"}


# Main entry point
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        app, host="127.0.0.1", port=int(os.environ.get("MIDDLEWARE_PORT", 9001))
    )
