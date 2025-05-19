using Microsoft.EntityFrameworkCore;
using BackendService.Data;

var builder = WebApplication.CreateBuilder(args);

// 1. 从配置读取连接串并注册 DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(
        "Server=localhost;Port=3306;Database=museumdb;User=root;Password=123456;SslMode=None;",
        new MySqlServerVersion(new Version(5, 7, 40))
    )
);

// 2. 添加控制器服务
builder.Services.AddControllers();

// 3. 允许跨域（CORS）
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod());
});

builder.WebHost.UseUrls("http://0.0.0.0:5000");
var app = builder.Build();

// 4. 管道配置
app.UseCors();
// app.UseHttpsRedirection();
app.MapControllers();

app.Run();

