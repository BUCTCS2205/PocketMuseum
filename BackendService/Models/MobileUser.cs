using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BackendService.Models;

[Table("mobile_users")]
public class MobileUser
{
    [Key]
    [Column("userid")]
    public int Id { get; set; }

    [Required]
    [MaxLength(50)]
    [Column("username")]
    public string Username { get; set; } = string.Empty;

    [MaxLength(100)]
    [Column("email")]
    public string? Email { get; set; }

    [Required]
    [MaxLength(255)]
    [Column("password")]
    public string Password { get; set; } = string.Empty;

    [Column("avatar")]
    public byte[]? Avatar { get; set; }

    [Column("registration_time")]
    public DateTime RegistrationTime { get; set; }

    [Column("last_login")]
    public DateTime? LastLogin { get; set; }

    [Column("status")]
    [MaxLength(20)]
    public string Status { get; set; } = string.Empty;
}
