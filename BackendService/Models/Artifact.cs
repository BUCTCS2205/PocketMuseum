using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BackendService.Models;

[Table("met_clear")]
public class Artifact
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("title")]
    public string Title { get; set; } = string.Empty;

    [Column("artist")]
    public string Artist { get; set; } = string.Empty;

    [Column("background")]
    public string Background { get; set; } = string.Empty;

    [Column("age")]
    public string Age { get; set; } = string.Empty;

    [Column("material")]
    public string Material { get; set; } = string.Empty;

    [Column("size")]
    public string Size { get; set; } = string.Empty;

    [Column("classify")]
    public string Classify { get; set; } = string.Empty;

    [Column("description")]
    public string Description { get; set; } = string.Empty;

    [Column("url")]
    public string Url { get; set; } = string.Empty;

    [Column("link")]
    public string Link { get; set; } = string.Empty;
}
