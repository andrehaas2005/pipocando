# CI (GitHub Actions)

O projeto possui workflow inicial em `.github/workflows/ios-ci.yml` com:

1. resolução de dependências SPM;
2. build do app no simulador iOS;
3. execução dos testes (`xcodebuild test`).

## Gatilhos
- `push` para `main`/`master`
- `pull_request` para `main`/`master`

## Requisitos
- Runner macOS com Xcode 15.4 disponível (`/Applications/Xcode_15.4.app`).
