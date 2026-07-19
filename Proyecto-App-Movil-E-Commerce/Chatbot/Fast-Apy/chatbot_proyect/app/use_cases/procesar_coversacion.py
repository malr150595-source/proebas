# app/use_cases/procesar_conversacion.py
from app.infraestructure.conversation_repository import IConversationRepository
from app.domain.entities.conversation import ChatMessageDTO

class ProcesarConversacionUseCase: 
    def __init__(self, repository: IConversationRepository): 
        self.repository = repository

    def ejecutar(self, conv_id: int, chat_message: ChatMessageDTO) -> None: 
        self.repository.registrar_mensaje_historial(
            conv_id=conv_id, 
            chatbot=0, 
            texto=chat_message.message
        )