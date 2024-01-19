import os
import socket

import requests
from fastapi import FastAPI, HTTPException
from dotenv import load_dotenv

app = FastAPI(title="Weather API")
load_dotenv()


def get_github_release_version():
    github_repo_owner = "shazolKh"
    github_repo_name = "bsTask"

    # request to the GitHub API to get information about the latest release
    github_api_url = f"https://api.github.com/repos/{github_repo_owner}/{github_repo_name}/releases/latest"
    response = requests.get(github_api_url)

    if response.status_code == 200:
        release_info = response.json()
        release_version = release_info["tag_name"]
        return release_version
    else:
        return os.getenv('VERSION')


@app.get("/api/weather/")
def root():
    hostname = socket.gethostname()
    weather_url = f"https://api.weatherapi.com/v1/current.json?q=dhaka&key={os.getenv('API_KEY')}"

    try:
        response = requests.get(weather_url)
        data = response.json()
        response_data = {
            "hostname": hostname,
            "datetime": data['current']['last_updated'],
            "version": get_github_release_version(),
            "weather": {
                "dhaka": {
                    "temperature": data['current']['temp_c'],
                    "temp_unit": 'C'
                }
            }
        }
        return response_data
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=f"Error fetching weather data: {e}")

    except Exception as ex:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {ex}")


@app.get("/api/health/")
def say_hello():
    return {"status": "ok"}
