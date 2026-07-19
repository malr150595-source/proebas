# app/use_cases/process_message_use_case.py
from app.infraestructure.db.sql_server_repository import SQLServerConversationRepository

class ProcessMessageUseCase:
    def __init__(self, repository: SQLServerConversationRepository):
        self.repository = repository

    def execute(self, username: str, message: str) -> dict:
        if not message or message.strip() == "":
            return self.repository._generar_fallback_local("BAD_REQUEST", "El mensaje no puede estar vacío.")
            
        return self.repository.procesar_mensaje_chatbot(username, message)