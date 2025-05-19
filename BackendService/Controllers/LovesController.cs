using BackendService.Data;
using BackendService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BackendService.Controllers;

[ApiController]
[Route("api/loves")]
public class LovesController : ControllerBase
{
    private readonly AppDbContext _db;

    public LovesController(AppDbContext db)
    {
        _db = db;
    }

    // GET api/loves
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var list = await _db.Loves.ToListAsync();
        return Ok(list);
    }

    // GET api/loves/artifact/{id}
    [HttpGet("artifact/{id:int}")]
    public async Task<IActionResult> GetByArtifactId(int id)
    {
        var loves = await _db.Loves.Where(c => c.ArtifactId == id)
                                   .ToListAsync();
        return Ok(loves);
    }

    // GET api/loves/mobile_user/{id}
    [HttpGet("mobile_user/{id:int}")]
    public async Task<IActionResult> GetByMobileUserId(int id)
    {
        var loves = await _db.Loves.Where(c => c.UserId == id)
                                   .OrderByDescending(c => c.LoveTime)
                                   .ToListAsync();
        return Ok(loves);
    }

    // POST api/loves
    [HttpPost]
    public async Task<IActionResult> Create(Love love)
    {
        love.LoveTime = DateTime.Now;

        _db.Loves.Add(love);
        await _db.SaveChangesAsync();
        return Ok(love);
    }

    // PUT api/loves
    [HttpPut]
    public async Task<IActionResult> Update(Love input)
    {
        var love = await _db.Loves.Where(l => l.UserId == input.UserId && l.ArtifactId == input.ArtifactId)
                                  .FirstOrDefaultAsync();

        if (love == null)
        {
            return NotFound();
        }

        love.LoveTime = input.LoveTime;
        await _db.SaveChangesAsync();
        return Ok(love);
    }

    // DELETE api/loves
    [HttpDelete]
    public async Task<IActionResult> Delete(Love input)
    {
        var love = await _db.Loves.Where(l => l.UserId == input.UserId && l.ArtifactId == input.ArtifactId)
                                  .FirstOrDefaultAsync();
        if (love == null)
        {
            return NotFound();
        }

        _db.Loves.Remove(love);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
