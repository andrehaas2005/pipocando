# Configuração de Ambiente (Secrets)

Para executar o app com integração de rede, defina os valores abaixo no ambiente/local CI:

- `API_KEY`: token Bearer da API TMDB
- `BASE_URL`: URL base da API (ex.: `https://api.themoviedb.org/3/`)
- `IMAGE_BASE_URL`: URL base de imagens (ex.: `https://image.tmdb.org/t/p/w500/`)

## Observações
- O arquivo `Pipocando/Config.plist` possui apenas placeholder para `APIKey` e **não** deve armazenar segredo real versionado.
- `Configuration.apiKey` usa variável de ambiente quando o valor do plist é placeholder.
