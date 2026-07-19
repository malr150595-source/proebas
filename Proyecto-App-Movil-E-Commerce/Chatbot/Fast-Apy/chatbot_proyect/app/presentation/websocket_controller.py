# app/presentation/websocket_controller.py
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from app.infraestructure.db.sql_server_repository import SQLServerConversationRepository
from app.use_cases.process_message_use_case import ProcessMessageUseCase

router = APIRouter()

# Instanciamos los componentes mapeados con el repositorio limpio
repository = SQLServerConversationRepository()
process_use_case = ProcessMessageUseCase(repository)

@router.websocket("/ws/chat")
async def websocket_chat_endpoint(websocket: WebSocket):
    await websocket.accept()
    # Inicializamos una variable de rastreo local por si se desconectan antes de enviar datos
    current_username = "Anónimo"
    try:
        while True:
            # 1. Recibir petición en formato JSON desde React Native / Postman
            data = await websocket.receive_json()
            
            username = data.get("username", "Anónimo").strip()
            message = data.get("message", "").strip()
            
            # Mantener actualizado el username asignado a esta conexión socket
            current_username = username

            # 2. Ejecutar lógica pasando por el Caso de Uso hacia el SP orquestador
            response_payload = process_use_case.execute(username, message)

            # 3. Retornar respuesta inmediata en tiempo real por el canal WebSocket
            await websocket.send_json(response_payload)

    except WebSocketDisconnect:
        # 💡 AQUÍ SE SOLUCIONA EL PROBLEMA:
        # Al perder la conexión con el cliente, el ciclo finaliza y ejecutamos el SP de cierre de inmediato.
        if current_username != "Anónimo":
            repository.cerrar_conversacion_activa(current_username)
            
    except Exception as e:
        try:
            await websocket.send_json({
                "Intent": "ERROR_WS",
                "mensaje": f"Excepción en el canal de datos: {str(e)}"
            })
        except:
            pass