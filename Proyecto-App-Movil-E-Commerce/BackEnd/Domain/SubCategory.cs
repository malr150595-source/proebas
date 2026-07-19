using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class SubCategory
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
        public int IdCreador { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int? IdModificador { get; set; }
        public DateTime? FechaModificacion { get; set; }
    }
}
