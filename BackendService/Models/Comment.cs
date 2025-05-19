using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BackendService.Models;

[Table("comments")]
public class Comment
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("user_id")]
    public int UserId { get; set; }

    [Column("artifact_id")]
    public int ArtifactId { get; set; }

    [Column("comment")]
    public string Text { get; set; } = "";

    [Column("comment_time")]
    public DateTime CommentTime { get; set; }

    [Column("passed")]
    public bool Passed { get; set; }
}
