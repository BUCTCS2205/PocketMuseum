using BackendService.Data;
using BackendService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BackendService.Controllers;

[ApiController]
[Route("api/comments")]
public class CommentsController : ControllerBase
{
    private readonly AppDbContext _db;

    public CommentsController(AppDbContext db)
    {
        _db = db;
    }

    // GET api/comments
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var list = await _db.Comments.ToListAsync();
        return Ok(list);
    }

    // GET api/comments/{id}
    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var comment = await _db.Comments.FindAsync(id);
        if (comment == null)
        {
            return NotFound();
        }
        return Ok(comment);
    }

    // GET api/comments/artifact/{id}
    [HttpGet("artifact/{id:int}")]
    public async Task<IActionResult> GetByArtifactId(int id)
    {
        var comments = await _db.Comments.Where(c => c.ArtifactId == id && c.Passed)
                                         .ToListAsync();
        return Ok(comments);
    }

    // GET api/comments/mobile_user/{id}
    [HttpGet("mobile_user/{id:int}")]
    public async Task<IActionResult> GetByMobileUserId(int id)
    {
        var comments = await _db.Comments.Where(c => c.UserId == id && c.Passed)
                                         .ToListAsync();
        return Ok(comments);
    }

    // POST api/comments
    [HttpPost]
    public async Task<IActionResult> Create(Comment comment)
    {
        comment.CommentTime = DateTime.Now;
        comment.Passed = true;

        _db.Comments.Add(comment);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(Get), new { id = comment.Id }, comment);
    }

    // PUT api/comments/{id}
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, Comment input)
    {
        var comment = await _db.Comments.FindAsync(id);
        if (comment == null)
        {
            return NotFound();
        }

        comment.UserId = input.UserId;
        comment.ArtifactId = input.ArtifactId;
        comment.Text = input.Text;
        comment.CommentTime = input.CommentTime;
        comment.Passed = input.Passed;

        await _db.SaveChangesAsync();
        return Ok(comment);
    }

    // DELETE api/comments/{id}
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var comment = await _db.Comments.FindAsync(id);
        if (comment == null)
        {
            return NotFound();
        }

        _db.Comments.Remove(comment);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
