using BackendService.Data;
using BackendService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BackendService.Controllers;

[ApiController]
[Route("api/artifacts")]
public class ArtifactsController : ControllerBase
{
    private readonly AppDbContext _db;

    public ArtifactsController(AppDbContext db)
    {
        _db = db;
    }

    // GET api/artifacts
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var list = await _db.Artifacts.ToListAsync();
        return Ok(list);
    }

    // GET api/artifacts/{id}
    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var artifact = await _db.Artifacts.FindAsync(id);
        if (artifact == null)
        {
            return NotFound();
        }
        return Ok(artifact);
    }

    // GET api/artifacts/search?name=xxx
    [HttpGet("search")]
    public async Task<IActionResult> SearchByName([FromQuery] string name)
    {
        var artifacts = await _db.Artifacts.Where(a => EF.Functions.Like(a.Title.ToLower(), $"%{name.ToLower()}%"))
                                           .ToListAsync();
        return Ok(artifacts);
    }

    // POST api/artifacts
    [HttpPost]
    public async Task<IActionResult> Create(Artifact artifact)
    {
        _db.Artifacts.Add(artifact);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(Get), new { id = artifact.Id }, artifact);
    }

    // PUT api/artifacts/{id}
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, Artifact input)
    {
        var artifact = await _db.Artifacts.FindAsync(id);
        if (artifact == null)
        {
            return NotFound();
        }

        artifact.Title = input.Title;
        artifact.Artist = input.Artist;
        artifact.Background = input.Background;
        artifact.Age = input.Age;
        artifact.Material = input.Material;
        artifact.Size = input.Size;
        artifact.Classify = input.Classify;
        artifact.Description = input.Description;
        artifact.Url = input.Url;
        artifact.Link = input.Link;

        await _db.SaveChangesAsync();
        return NoContent();
    }

    // DELETE api/artifacts/{id}
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var artifact = await _db.Artifacts.FindAsync(id);
        if (artifact == null)
        {
            return NotFound();
        }

        _db.Artifacts.Remove(artifact);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
