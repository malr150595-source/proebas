# app/infraestructure/conversation_repository.py
from abc import ABC, abstractmethod
from typing import Dict, Any, List, Optional

class IConversationRepository(ABC):
    
    @abstractmethod
    def db_connection(self): # 👈 ASEGÚRATE DE QUE ESTO EXISTA AQUÍ
        pass

    @abstractmethod
    def orquestar_conversacion(self, username: str) -> int:
        pass

    @abstractmethod
    def orquestar_y_procesar_mensaje(self, username: str, mensaje_usuario: str) -> dict:
        pass

    @abstractmethod
    def ejecutar_agregar_carrito_v2(self, username: str, termino_busqueda: str, conv_id: int, cantidad: int = 1) -> dict:
        pass

    @abstractmethod
    def orquestar_y_procesar_mensaje_v2(self, username: str, mensaje_usuario: str, conv_id: int) -> dict:
        pass

    @abstractmethod
    def verificar_carrito_compras(self, username: str) -> dict:
        pass

    @abstractmethod
    def registrar_mensaje_historial(self, conv_id: int, chatbot: int, texto: str, regla_id: Optional[int] = None, metadata: Optional[str] = None) -> None:
        pass

    @abstractmethod
    def obtener_stopwords_carrito(self) -> List[str]:
        pass
        
    # 💡 Nuevo método obligatorio: Extrae categorías, marcas y sinónimos de la BD
    @abstractmethod
    def obtener_diccionario_palabras(self) -> List[str]:
        pass

    @abstractmethod
    def obtener_stopwords(self, tipo: str) -> list:
        pass
        
    @abstractmethod
    def obtener_sinonimos(self) -> dict:
        pass