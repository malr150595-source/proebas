# app/infraestructure/llm_service.py

class LLMHumanizerService:
    def __init__(self):
        """
        Constructor limpio. 
        Ya no se inicializa ningún cliente de Google ni se validan API Keys.
        """
        pass

    def humanizar_respuesta(self, username: str, mensaje_usuario: str, intencion: str, respuesta_sql: str, catalogo_json: list, historial: list = None) -> str:
        """
        Bypass directo: Ya no llama a ninguna IA. 
        Retorna de inmediato el mensaje sugerido y estructurado por la base de datos.
        """
        # Devolvemos directamente el mensaje que viene de tu SQL Server
        return respuesta_sql