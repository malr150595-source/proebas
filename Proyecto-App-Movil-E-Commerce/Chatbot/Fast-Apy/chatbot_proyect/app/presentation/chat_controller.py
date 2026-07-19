# app/presentation/chat_controller.py
from fastapi import APIRouter, HTTPException, Depends
from app.infraestructure.db.sql_server_repository import SQLServerConversationRepository
from app.use_cases.start_conversation import StartConversationUseCase
from pydantic import BaseModel

router = APIRouter(prefix="/chat", tags=["Chatbot"])

def get_repository():
    return SQLServerConversationRepository()

class StartChatDTO(BaseModel):
    username: str

@router.post("/start")
def iniciar_conversacion(dto: StartChatDTO, repo=Depends(get_repository)):
    try:
        use_case = StartConversationUseCase(repo)
        conversation_id = use_case.execute(dto.username)
        
        return {
            "status": "SUCCESS",
            "message": "Conversación inicializada correctamente.",
            "conversation_id": str(conversation_id)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))