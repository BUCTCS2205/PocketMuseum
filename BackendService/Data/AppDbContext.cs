using BackendService.Models;
using Microsoft.EntityFrameworkCore;

namespace BackendService.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<MobileUser> MobileUsers { get; set; } = null!;

    public DbSet<Artifact> Artifacts { get; set; } = null!;

    public DbSet<Comment> Comments { get; set; } = null!;

    public DbSet<Love> Loves { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<MobileUser>()
            .Property(u => u.Id)
            .ValueGeneratedOnAdd();

        modelBuilder.Entity<MobileUser>()
            .HasIndex(u => u.Username)
            .HasDatabaseName("idx_mobile_username")
            .IsUnique();

        modelBuilder.Entity<Artifact>()
            .Property(a => a.Id)
            .ValueGeneratedOnAdd();

        modelBuilder.Entity<Comment>()
            .Property(c => c.Id)
            .ValueGeneratedOnAdd();

        modelBuilder.Entity<Love>()
            .HasKey(e => new { e.UserId, e.ArtifactId });
    }
}
