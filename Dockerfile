#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
WORKDIR /src
COPY ["ApiREST.csproj", ""]
RUN dotnet restore "./ApiREST.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ApiREST.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ApiREST.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ApiREST.dll"]