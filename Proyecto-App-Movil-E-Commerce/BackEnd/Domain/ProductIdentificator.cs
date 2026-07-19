using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class ProductIdentificator
    {
        public int Id { get; set; }
        public int IdCategoria { get; set; }
        public string NombreCategoria { get; set; } = string.Empty;
        public int IdSubCategoria { get; set; }
        public string NombreSubCategoria { get; set; } = string.Empty;
        public int IdSegmento { get; set; }
        public string NombreSegmento { get; set; } = string.Empty;
        public int IdCreador { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int? IdModificador { get; set; }
        public DateTime? FechaModificacion { get; set; }
    }
}
