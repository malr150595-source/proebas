using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Mark
    {
        public int IdMarca { get; set; }
        public string NombreMarca { get; set; } = string.Empty;
        public string DescripcionMarca { get; set; } = string.Empty;
        public int CreadorMarcaId { get; set; }
        public DateTime CreadorMarcaFecha { get; set; }
        public int? MarcaModificadorId { get; set; }
        public DateTime? MarcaModificadorFecha { get; set; }
    }
}
