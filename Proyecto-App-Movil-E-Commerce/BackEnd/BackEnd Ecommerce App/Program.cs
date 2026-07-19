using Application.Interface;
using Application.Services;
using Infraestructure.Db;
using Infraestructure.Infraestructure;
using Infraestructure.Repository;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Scalar.AspNetCore;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Cadena de conexión a SQL Server
var ConnectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddSingleton(new DBConectionFactory(ConnectionString!));

// =========================================================================
// 1. CONFIGURACIÓN DE SEGURIDAD Y TOKEN JWT
// =========================================================================
// Enlazamos la interfaz con la clase física que firma los tokens criptográficos
builder.Services.AddScoped<IJwtTokenGenerator, JwtTokenGenerator>();

// Leemos la clave secreta desde el appsettings.json para validar firmas del cliente
var secretKey = builder.Configuration["JwtSettings:SecretKey"] ?? "SUPER_SECRET_KEY_IMPORTANT_E_COMMERCE_APP_2026_CORE_10";
var key = Encoding.UTF8.GetBytes(secretKey);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = true,
        ValidIssuer = builder.Configuration["JwtSettings:Issuer"],
        ValidateAudience = true,
        ValidAudience = builder.Configuration["JwtSettings:Audience"],
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero
    };
});

// =========================================================================
// 2. INYECCIÓN DE DEPENDENCIAS (MÓDULOS DEL SISTEMA)
// =========================================================================

// Módulo de Estado
builder.Services.AddScoped<ITbl_Status, Tbl_Status_Repository>();
builder.Services.AddScoped<Tbl_Status_Service>();

// Módulo de Usuarios, Repositorios y Login Asíncrono (CORREGIDO)
builder.Services.AddScoped<ITbl_Users, Tbl_User_Repository>();
builder.Services.AddScoped<Tbl_Users_Service>();
builder.Services.AddScoped<JwtTokenGenerator_service>();

// Módulo de Categorías
builder.Services.AddScoped<ICategoriesRepository, Categories_Repository>();
builder.Services.AddScoped<Categories_Service>();

// Módulo de Direcciones de Usuario
builder.Services.AddScoped<ITbl_UserAddresses, Tbl_UserAddress_Repository>();
builder.Services.AddScoped<Tbl_UserAddresses_Service>();

// Módulo de Subcategorías y Segmentos
builder.Services.AddScoped<ISubcategory_Repository, SubCategories_Repository>();
builder.Services.AddScoped<SubCategories_Service>();
builder.Services.AddScoped<ISegmentRepository, Segments_Repository>();
builder.Services.AddScoped<Segments_Service>();

// Módulo de Productos y Atributos
builder.Services.AddScoped<IProductIdentificatorsRepository, ProductIdentificators_Repository>();
builder.Services.AddScoped<ProductIdentificators_Service>();
builder.Services.AddScoped<IProvidersRepository, Providers_Repository>();
builder.Services.AddScoped<Providers_Service>();
builder.Services.AddScoped<IMarksRepository, Marks_Repository>();
builder.Services.AddScoped<Marks_Service>();
builder.Services.AddScoped<IProductsRepository, Products_Repository>();
builder.Services.AddScoped<Products_Service>();
builder.Services.AddScoped<IProductVariableTypesRepository, ProductVariableTypes_Repository>();
builder.Services.AddScoped<ProductVariableTypes_Service>();
builder.Services.AddScoped<IProductImagesRepository, ProductImages_Repository>();
builder.Services.AddScoped<ProductImages_Service>();
builder.Services.AddScoped<IProductVariablesRepository, ProductVariables_Repository>();
builder.Services.AddScoped<ProductVariables_Service>();

// Módulo de Inventario (Stocks)
builder.Services.AddScoped<IStocksRepository, Stocks_Repository>();
builder.Services.AddScoped<Stocks_Service>();

// Módulo de Carrito de Compras
builder.Services.AddScoped<ICartsRepository, Carts_Repository>();
builder.Services.AddScoped<Carts_Service>();
builder.Services.AddScoped<ICartDetailsRepository, CartDetails_Repository>();
builder.Services.AddScoped<CartDetails_Service>();

// Módulo de Métodos de Pago y Órdenes
builder.Services.AddScoped<IPaymentMethodTypesRepository, PaymentMethodTypes_Repository>();
builder.Services.AddScoped<PaymentMethodTypes_Service>();
builder.Services.AddScoped<IUserPaymentMethodsRepository, UserPaymentMethods_Repository>();
builder.Services.AddScoped<UserPaymentMethods_Service>();
builder.Services.AddScoped<IPaymentOrdersRepository, PaymentOrders_Repository>();
builder.Services.AddScoped<PaymentOrders_Service>();
builder.Services.AddScoped<IPaymentOrderDetailsRepository, PaymentOrderDetails_Repository>();
builder.Services.AddScoped<PaymentOrderDetails_Service>();

// Módulo de Movimientos de Kárdex / Stock
builder.Services.AddScoped<IStockMovementTypesRepository, StockMovementTypes_Repository>();
builder.Services.AddScoped<StockMovementTypes_Service>();
builder.Services.AddScoped<IStockMovementsRepository, StockMovements_Repository>();
builder.Services.AddScoped<StockMovements_Service>();
builder.Services.AddScoped<IStockMovementDetailsRepository, StockMovementDetails_Repository>();
builder.Services.AddScoped<StockMovementDetails_Service>();

// Módulo de Roles, Permisos y Seguridad
builder.Services.AddScoped<IRolesRepository, Roles_Repository>();
builder.Services.AddScoped<Roles_Service>();
builder.Services.AddScoped<IPermissionsRepository, Permissions_Repository>();
builder.Services.AddScoped<Permissions_Service>();
builder.Services.AddScoped<IRolePermissionMatrixRepository, RolePermissionMatrix_Repository>();
builder.Services.AddScoped<RolePermissionMatrix_Service>();
builder.Services.AddScoped<IUserRolesRepository, UserRoles_Repository>();
builder.Services.AddScoped<UserRoles_Service>();

// Configuración de CORS para la conexión con React Native
builder.Services.AddCors(po =>
{
    po.AddPolicy("AllowAll", policy =>
    {
        policy.WithOrigins()
        .AllowAnyMethod()
        .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configuración de Swagger
app.UseSwagger();
app.UseSwaggerUI(u =>
{
    u.SwaggerEndpoint("/swagger/v1/swagger.json", "Api Ecommerce Movil");
    //u.RoutePrefix = string.Empty;
});

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference(options =>
    {
        options.WithTitle("API E-Commerce Móvil")
               .WithTheme(ScalarTheme.DeepSpace) // Un tema oscuro genial
               .WithDefaultHttpClient(ScalarTarget.CSharp, ScalarClient.HttpClient);
    });
}

app.UseCors("AllowAll");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.Run();