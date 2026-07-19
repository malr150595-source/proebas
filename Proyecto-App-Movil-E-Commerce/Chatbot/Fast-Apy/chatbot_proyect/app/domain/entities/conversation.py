# app/domain/entities/conversation.py (Extensión)
from pydantic import BaseModel, Field
from typing import Optional, List

class ProductoCatalogoDTO(BaseModel):
    id_variante: int
    categoria: str
    subcategoria: str
    segmento: str
    nombre_producto: str
    variante: str
    precio: float
    stock: Optional[int] = 0
    cantidad: Optional[int] = 0

class RespuestaBot(BaseModel):
    conversation_id: str
    emisor: str = "bot"
    regla_id: Optional[int] = None
    nombre_regla: Optional[str] = None
    Intent: str
    mensaje: str
    catalogo_productos: List[ProductoCatalogoDTO] = []
    requiere_confirmacion: bool = False
    escalado_humano: bool = False