# 使用 .NET 8 SDK 建置
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 複製整個專案（包含 .csproj）
COPY . .

# 還原 + 發行
RUN dotnet restore
RUN dotnet publish -c Release -o /app

# 使用 ASP.NET 執行環境
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app .

# Render 提供 PORT 環境變數
ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT}

ENTRYPOINT ["dotnet", "WebApplication1.dll"]
