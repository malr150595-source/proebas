using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class ProductImage
    {
        public int ProductImageId { get; set; }
        public int ProductImageProductId { get; set; }
        public string ProductImageURL { get; set; } = string.Empty;
        public string ProductImageDescription { get; set; } = string.Empty;
        public bool ProductImageIsPrincipal { get; set; }
        public int ProductImageCreatorId { get; set; }
        public DateTime ProductImageCreationDate { get; set; }
        public int? ProductImageModificatorId { get; set; }
        public DateTime? ProductImageModificationDate { get; set; }
    }
}
