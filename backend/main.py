from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
import json
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()

app = FastAPI(title="Impact Candle API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
print("=== KEY CHECK ===")
print("Key length:", len(GEMINI_API_KEY) if GEMINI_API_KEY else 0)

if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)

class SimulateRequest(BaseModel):
    event: str

class SimulateResponse(BaseModel):
    event: str
    scores: dict
    reasons: dict
    confidence: float
    summary: str
    provider_used: str

SYSTEM_PROMPT = """
You are an elite macro trader and market impact analyst specializing in Gold (XAUUSD), DXY, US100, US30, and SP500.

Estimate the likely market impact of the given event.

Rules:
- Score each asset from -10 to +10
- Be realistic based on historical market behavior
- Output ONLY valid JSON in this exact format:

{
  "scores": {
    "Gold": number,
    "DXY": number,
    "US100": number,
    "US30": number,
    "SP500": number
  },
  "reasons": {
    "Gold": "short reason",
    "DXY": "short reason",
    "US100": "short reason",
    "US30": "short reason",
    "SP500": "short reason"
  },
  "confidence": 0.0 to 1.0,
  "summary": "1 sentence summary"
}
"""

def parse_ai_response(content: str) -> dict:
    if "```" in content:
        content = content.split("```")[1]
        if content.startswith("json"):
            content = content[4:]
    return json.loads(content.strip())

@app.post("/simulate", response_model=SimulateResponse)
async def simulate_event(request: SimulateRequest):
    if not GEMINI_API_KEY:
        raise HTTPException(status_code=500, detail="GEMINI_API_KEY not set")

    event = request.event.strip()
    if not event:
        raise HTTPException(status_code=400, detail="Event cannot be empty")

    try:
        model = genai.GenerativeModel("gemini-1.5-flash")
        prompt = SYSTEM_PROMPT + f"\n\nEvent: {event}"
        
        response = model.generate_content(prompt)
        content = response.text.strip()
        data = parse_ai_response(content)

        return {
            "event": event,
            "scores": data["scores"],
            "reasons": data["reasons"],
            "confidence": data.get("confidence", 0.75),
            "summary": data.get("summary", "Simulated impact"),
            "provider_used": "gemini"
        }

    except Exception as e:
        print("=== ERROR ===")
        print(str(e))
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
def health():
    return {
        "status": "Impact Candle API running",
        "provider": "gemini",
        "ready": bool(GEMINI_API_KEY)
    }
