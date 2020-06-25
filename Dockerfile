#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app


FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["WingtipToys.ProductService.csproj", ""]
RUN dotnet restore "./WingtipToys.ProductService.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WingtipToys.ProductService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WingtipToys.ProductService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WingtipToys.ProductService.dll"]