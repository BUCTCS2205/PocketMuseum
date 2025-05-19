using System.ComponentModel.DataAnnotations.Schema;

namespace BackendService.Models;

[Table("loves")]
public class Love
{
    [Column("user_id")]
    public int UserId { get; set; }

    [Column("artifact_id")]
    public int ArtifactId { get; set; }

    [Column("love_time")]
    public DateTime LoveTime { get; set; }
}
