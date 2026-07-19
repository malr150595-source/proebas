# app/infrastructure/conversation_repository.py
import json
import pyodbc
import os
from contextlib import contextmanager

class SQLServerConversationRepository:
    def __init__(self):
        # 1. Extraemos los parámetros individuales del .env que proporcionaste
        driver = os.getenv("DB_DRIVER", "{ODBC Driver 17 for SQL Server}")
        server = os.getenv("DB_SERVER", "localhost")
        database = os.getenv("DB_DATABASE", "DB_EcommerceAgent")
        username = os.getenv("DB_USER", "user_agent_db")
        password = os.getenv("DB_PASSWORD", "Marianne2502")

        # 2. Construimos la cadena de conexión dinámica limpia
        self.connection_string = (
            f"DRIVER={driver};"
            f"SERVER={server};"
            f"DATABASE={database};"
            f"UID={username};"
            f"PWD={password};"
            f"Encrypt=no;" # Vital si estás en desarrollo local sin certificados SSL configurados
        )

    @contextmanager
    def db_connection(self):
        conn = pyodbc.connect(self.connection_string)
        try:
            yield conn
        finally:
            conn.close()

    def procesar_mensaje_chatbot(self, username: str, message: str) -> dict:
        """
        Llama al SP centralizado USP_ORQUESTAR_Y_PROCESAR_CHAT.
        Este gestionará secuencialmente: Saludo, Búsqueda, Adición y Verificación.
        """
        try:
            with self.db_connection() as conn:
                with conn.cursor() as cursor:
                    # Estructura JSON exacta requerida por tu orquestador T-SQL
                    payload_json = json.dumps({
                        "username": username,
                        "message": message
                    }, ensure_ascii=False)

                    # Invocación directa
                    query = "EXEC [dbo].[USP_ORQUESTAR_Y_PROCESAR_CHAT] @p_ChatRequestJson = ?"
                    cursor.execute(query, (payload_json,))
                    row = cursor.fetchone()

                    if row and row[0]:
                        return json.loads(row[0])
                    
                    return self._generar_fallback_local("FALLBACK_EMPTY", "El motor de base de datos no retornó información.")

        except Exception as e:
            return self._generar_fallback_local("FALLBACK_CRITICAL", f"Error de comunicación con SQL Server: {str(e)}")

    def _generar_fallback_local(self, intent: str, mensaje: str) -> dict:
        return {
            "conversation_id": "0",
            "emisor": "bot",
            "regla_id": 0,
            "nombre_regla": "FALLBACK",
            "Intent": intent,
            "mensaje": mensaje,
            "catalogo_productos": [],
            "requiere_confirmacion": False,
            "escalado_humano": False
        }
    
    def cerrar_conversacion_activa(self, username: str) -> None:
        """
        Invoca al SP para establecer la FechaFin y desactivar la conversación activa.
        """
        try:
            with self.db_connection() as conn:
                with conn.cursor() as cursor:
                    query = "EXEC [dbo].[Sp_HistorialConversaciones_Cerrar] @UsuarioID = ?"
                    cursor.execute(query, (username,))
                    conn.commit()
        except Exception as e:
            # Log de advertencia para que no rompa el flujo de desconexión principal
            print(f"Advertencia al cerrar conversación de {username}: {str(e)}")