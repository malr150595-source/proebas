using System;
using System.Collections.Generic;
using System.Text;

using System;

namespace Application.DTOs
{
    public class Tbl_UserAddress_DTOs
    {
        public int UserAddressId { get; set; }
        public int UserAddressUserId { get; set; }
        public int UserAddressCountryId { get; set; }
        public int UserAddressZIPCode { get; set; }
        public string? UserAddressDescription { get; set; }
        public bool UserAddressIsPrincipal { get; set; }
        public int UserAddressCreatorId { get; set; }
        public DateTime UserAddressCreationDate { get; set; }
        public int? UserAddressModificatorId { get; set; }
        public DateTime? UserAddressModificationDate { get; set; }
    }

    public class Tbl_UserAddress_Insert_DTOs
    {
        public int UserAddressUserId { get; set; }
        public int UserAddressCountryId { get; set; }
        public int UserAddressZIPCode { get; set; }
        public string? UserAddressDescription { get; set; }
        public bool UserAddressIsPrincipal { get; set; }
        public DateTime? UserAddressCreationDate { get; set; }
        public int UserAddressCreatorId { get; set; }
    }

    public class Tbl_UserAddress_Update_DTOs
    {
        public int UserAddressId { get; set; }
        public int UserAddressUserId { get; set; }
        public int UserAddressCountryId { get; set; }
        public int UserAddressZIPCode { get; set; }
        public string? UserAddressDescription { get; set; }
        public bool UserAddressIsPrincipal { get; set; }
        public int UserAddressModificatorId { get; set; }
        public DateTime? UserAddressModificationDate { get; set; }
    }

    public class Tbl_UserAddress_Delete_DTOs
    {
        public int UserAddressId { get; set; }
        public int UserAddressModificatorId { get; set; }
        public DateTime? UserAddressModificationDate { get; set; }
    }
}

