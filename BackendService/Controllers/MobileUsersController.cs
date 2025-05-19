using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BackendService.Data;
using BackendService.Models;

namespace BackendService.Controllers;

[ApiController]
[Route("api/mobile_users")]
public class MobileUsersController : ControllerBase
{
    private readonly AppDbContext _db;

    public MobileUsersController(AppDbContext db)
    {
        _db = db;
    }

    // GET api/mobile_users
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var list = await _db.MobileUsers.ToListAsync();
        return Ok(list);
    }

    // GET api/mobile_users/{id}
    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var user = await _db.MobileUsers.FindAsync(id);
        if (user == null)
        {
            return NotFound();
        }
        return Ok(user);
    }

    // GET api/mobile_users/name?name=xxx
    [HttpGet("name")]
    public async Task<IActionResult> GetByName([FromQuery] string name)
    {
        var user = await _db.MobileUsers.FirstOrDefaultAsync(u => u.Username == name);
        if (user == null)
        {
            return NotFound();
        }
        return Ok(user);
    }

    // GET api/mobile_users/email?email=xxx@example.com
    [HttpGet("email")]
    public async Task<IActionResult> GetByEmail([FromQuery] string email)
    {
        var user = await _db.MobileUsers.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null)
        {
            return NotFound();
        }
        return Ok(user);
    }

    // POST api/mobile_users
    [HttpPost]
    public async Task<IActionResult> Create(MobileUser user)
    {
        if (_db.MobileUsers.Any(u => u.Id != user.Id &&
                               (u.Username == user.Username || u.Email == user.Email)))
        {
            return Conflict(new { message = "用户名或邮件已存在" });
        }

        user.RegistrationTime = DateTime.Now;
        user.LastLogin = user.RegistrationTime;

        _db.MobileUsers.Add(user);
        await _db.SaveChangesAsync();
        return CreatedAtAction(nameof(Get), new { id = user.Id }, user);
    }

    // PUT api/mobile_users/{id}
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, MobileUser input)
    {
        var user = await _db.MobileUsers.FindAsync(id);
        if (user == null)
        {
            return NotFound();
        }

        if (_db.MobileUsers.Any(u => u.Id != user.Id &&
                                (u.Username == user.Username || u.Email == user.Email)))
        {
            return Conflict(new { message = "用户名或邮件已存在" });
        }

        user.Username = input.Username;
        user.Email = input.Email;
        user.Password = input.Password;
        user.Avatar = input.Avatar;
        user.LastLogin = input.LastLogin;

        await _db.SaveChangesAsync();
        return Ok(user);
    }

    // DELETE api/mobile_users/{id}
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var user = await _db.MobileUsers.FindAsync(id);
        if (user == null)
        {
            return NotFound();
        }

        _db.MobileUsers.Remove(user);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
