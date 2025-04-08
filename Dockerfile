# Usar una imagen base de .NET para la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Usar la imagen SDK de .NET 8 para la construcción del proyecto
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Instalar Node.js para permitir el uso de npm
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# Copiar el archivo de proyecto y restaurar las dependencias
COPY ["SamaraProject1/SamaraProject1.csproj", "SamaraProject1/"]
RUN dotnet restore "SamaraProject1/SamaraProject1.csproj"

# Copiar todo el código y construir el proyecto
COPY . .
WORKDIR "/src/SamaraProject1"
RUN dotnet build "SamaraProject1.csproj" -c Release -o /app/build

# Publicar la aplicación
FROM build AS publish
RUN dotnet publish "SamaraProject1.csproj" -c Release -o /app/publish

# Imagen final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SamaraProject1.dll"]
