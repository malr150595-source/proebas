using System;
using System.Collections.Generic;
using System.Text;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Domain
{
    public class D_Users
    {
        public int UserId { get; set; }
        public string? UserFullName { get; set; }
        public string? UserName { get; set; }
        public byte[]? UserPassword { get; set; }
        public string? UserEmail { get; set; }
        public string? userPhoneNumber { get; set; }
        public int UserCountryId { get; set; }
	    public int UserGenderId { get; set; }
        public Date? UserBirthDay { get; set; }
        public int UserCreatorId { get; set; }
        public int UserCreationDate { get; set; }
	    public int UserModificatorId { get; set; }
	    public DateTime UserModificationDate { get;set;}
	    public int UserStatusId { get; set; }
    }
}
