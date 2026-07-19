# app/use_cases/start_conversation.py
from app.infraestructure.conversation_repository import IConversationRepository

class StartConversationUseCase:
    def __init__(self, repository: IConversationRepository):
        self.repository = repository

    def execute(self, username: str) -> int:
        return self.repository.orquestar_conversacion(username)