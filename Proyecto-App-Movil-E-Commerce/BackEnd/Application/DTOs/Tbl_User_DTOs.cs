using System;

namespace Application.DTOs
{
    public class Tbl_User_DTOs
    {
        public int UserId { get; set; }
        public string? UserFullName { get; set; }
        public string? UserName { get; set; }
        public string? UserPassword { get; set; }
        public string? UserEmail { get; set; }
        public string? UserPhoneNumber { get; set; }
        public int UserCountryId { get; set; }
        public int UserGenderId { get; set; }
        public DateTime? UserBirthDay { get; set; }
        public int UserCreatorId { get; set; }
        public DateTime UserCreationDate { get; set; }
        public int? UserModificatorId { get; set; }
        public DateTime? UserModificationDate { get; set; }
        public string? Status { get; set; }
    }

    public class Tbl_User_Insert_DTOs
    {
        public string? UserFullName { get; set; }
        public string? UserName { get; set; }
        public string? UserPassword { get; set; }
        public string? UserEmail { get; set; }
        public string? UserPhoneNumber { get; set; }
        public int UserCountryId { get; set; }
        public int UserGenderId { get; set; }
        public DateTime? UserBirthDay { get; set; }
        public int UserCreatorId { get; set; }
        public DateTime? UserCreationDate { get; set; }
    }

    public class Tbl_User_Update_DTOs
    {
        public int UserId { get; set; }
        public string? UserFullName { get; set; }
        public string? UserName { get; set; }
        public string? UserPassword { get; set; }
        public string? UserEmail { get; set; }
        public string? UserPhoneNumber { get; set; }
        public int UserCountryId { get; set; }
        public int UserGenderId { get; set; }
        public DateTime? UserBirthDay { get; set; }
        public int UserModificatorId { get; set; }
        public DateTime? UserModificationDate { get; set; }
    }

    public class Tbl_User_Delete_DTOs
    {
        public int UserId { get; set; }
        public int UserModificatorId { get; set; }
        public DateTime? UserModificationDate { get; set; }
    }
    public class Login_DTOs
    {
        public string? UserName { get; set; }
        public string? UserPassword { get; set; }
    }
}