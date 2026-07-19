using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Product
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string ProductDescription { get; set; } = string.Empty;
        public int ProductProductIdentificatorId { get; set; }

        // --- NUEVAS PROPIEDADES PARA INNER JOIN ---
        public string CategoryName { get; set; } = string.Empty;
        public string SubCategoryName { get; set; } = string.Empty;
        public string SegmentName { get; set; } = string.Empty;

        public int ProductMarkByProviderId { get; set; }

        // --- NUEVAS PROPIEDADES PARA INNER JOIN ---
        public string MarkName { get; set; } = string.Empty;
        public string ProviderName { get; set; } = string.Empty;

        public int ProductCreatorId { get; set; }
        public DateTime ProductCreationDate { get; set; }
        public int? ProductModificatorId { get; set; }
        public DateTime? ProductModificationDate { get; set; }
    }
}
