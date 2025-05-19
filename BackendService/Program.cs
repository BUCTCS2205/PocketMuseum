using Microsoft.EntityFrameworkCore;
using BackendService.Data;

var builder = WebApplication.CreateBuilder(args);

// 1. �����ö�ȡ���Ӵ���ע�� DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(
        "Server=localhost;Port=3306;Database=museumdb;User=root;Password=123456;SslMode=None;",
        new MySqlServerVersion(new Version(5, 7, 40))
    )
);

// 2. ��ӿ���������
builder.Services.AddControllers();

// 3. �������CORS��
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod());
});

builder.WebHost.UseUrls("http://0.0.0.0:5000");
var app = builder.Build();

// 4. �ܵ�����
app.UseCors();
// app.UseHttpsRedirection();
app.MapControllers();

app.Run();

