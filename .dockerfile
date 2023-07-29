#-------api projesi için hazırladığım docker imajı ------------
  
# 1. İlk aşamada, .NET 6.0 SDK'sının bulunduğu temel bir imaj kullanılır.
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# 2. Çalışma dizini "/app" olarak belirlenir.
WORKDIR /app

# 3. Uygulama için kullanılan portlar belirtilir.
EXPOSE 80
EXPOSE 443

# 4. Uygulama dosyaları ile projenin csproj dosyası kopyalanır.
COPY *.csproj ./

# 5. Proje bağımlılıkları "dotnet restore" komutu ile yüklenir.
RUN dotnet restore

# 6. Uygulama dosyaları kopyalanır.
COPY . ./

# 7. "dotnet publish" komutu ile release modunda uygulama derlenir ve "/app/out" klasörüne çıktı alınır.
RUN dotnet publish -c release -o out

# 8. İkinci aşama: Nihai Docker imajını oluşturmak için yeni bir aşama başlatılır.
FROM mcr.microsoft.com/dotnet/sdk:6.0

# 9. Çalışma dizini "/app" olarak belirlenir.
WORKDIR /app

# 10. Önceki aşamada oluşturulan "/app/out" klasöründeki uygulama dosyaları kopyalanır.
COPY --from=build-env /app/out .

# 11. Uygulama başlatılır.
ENTRYPOINT ["dotnet", "littleviewservice.dll"]
