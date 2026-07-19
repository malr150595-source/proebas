# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.presentation.websocket_controller import router as ws_router
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(
    title="E-commerce Chatbot Agent API", 
    version="2.0.0"
)

# Configuración de CORS vital para conexiones WebSocket desde dispositivos físicos/emuladores
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Registramos el endpoint del Chatbot
app.include_router(ws_router)

@app.get("/")
def read_root():
    return {"status": "ONLINE", "bot_features": ["saludar", "buscar_productos", "agregar_carrito", "verificar_carrito"]}