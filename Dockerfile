# 使用 .NET 8 SDK 建置
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# 複製專案檔並還原套件
COPY *.csproj .
RUN dotnet restore

# 複製所有原始碼並建置
COPY . .
RUN dotnet publish -c Release -o out

# 建立最小化執行階段映像檔
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

# Render 會自動設定 PORT 環境變數
ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT}
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
