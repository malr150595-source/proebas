using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Provider
    {
        public int ProveedorId { get; set; }
        public string? ProveedorNombre { get; set; } = string.Empty;
        public string? ProveedorDescripcion { get; set; } = string.Empty;
        public int ProveedorCreadorId { get; set; }
        public DateTime ProveedorCreadorFecha { get; set; }
        public int? ProveedorIdModificacion { get; set; }
        public DateTime? ProveedorModificacionFecha { get; set; }
    }
}
