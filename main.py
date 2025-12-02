from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional, Dict, Any
import time

app = FastAPI()

class PPTRequest(BaseModel):
    topic: str
    extraInfoSource: str
    email: str
    accessId: str
    presentationFor: str
    slideCount: int
    language: str
    template: str
    model: str
    aiImages: bool
    imageForEachSlide: bool
    googleImage: bool
    googleText: bool
    watermark: Optional[Dict[str, Any]] = None

class PPTData(BaseModel):
    url: str

class PPTResponse(BaseModel):
    success: bool
    data: Optional[PPTData] = None
    message: Optional[str] = None

@app.post("/generate-ppt", response_model=PPTResponse)
def generate_ppt(request: PPTRequest):
    print(request)
    time.sleep(5)
    return PPTResponse(
        success=True,
        data=PPTData(url="https://professional.heart.org/-/media/PHD-Files/Research/Strategic-Networks/Project-Status-Template-PPT.pptx"),
        message="Presentation generated successfully"
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
