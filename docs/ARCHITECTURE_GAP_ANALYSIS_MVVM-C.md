# Gap Analysis — Blueprint MVVM-C vs Estado atual do projeto

## Status atual (após Sprint A expandido)

### Itens fechados nesta etapa
1. **Fluxo completo com DataSource na cadeia**
   - Home/Details/Calendar agora seguem `View -> ViewModel -> UseCase -> Repository -> RemoteDataSource -> Service/Network`.
2. **Details em async/await ponta a ponta**
   - Use case e repositório de detalhes já estão em `async throws`.
3. **Inversão de dependência sem singleton padrão em produção**
   - Serviços e network exigem injeção explícita.
4. **MVVM-C uniforme nas features de tab alvo**
   - Profile agora possui `ProfileCoordinator + ProfileViewModel + state`.
   - Watchlist agora possui `WatchlistCoordinator + WatchlistViewModel + state`.
5. **State machine padronizada**
   - Watchlist/Profile migradas para `idle/loading/loaded/error`.
6. **Design System profissional (mínimo do blueprint)**
   - Tokens adicionais: `Radius`, `Opacity`, `Elevation`.
   - Componentes base adicionados: `PrimaryButton`, `SecondaryButton`, `TagView`, `RatingBadge`, `LoadingView`, `ErrorView`.
7. **Qualidade e governança**
   - Pipeline CI atualizado com etapas de SwiftLint e SwiftFormat.
   - Testes adicionais para `DetailsViewModel`, `WatchlistViewModel` e `ProfileViewModel`.
   - Testes de render (snapshot básico) para componentes do Design System.
8. **Modularização incremental iniciada**
   - Scaffold de pacotes locais SPM criado em `Packages/PipocandoCore` e `Packages/PipocandoDesignSystem`.

## Pendências remanescentes para aderência máxima (hardening)
- **Domain vs Data (DTO/Mappers em escala total)**:
  - A separação por DataSource foi aplicada nos fluxos críticos, mas a migração completa de todos os modelos para `Entities + DTO + Mappers` ainda exige expansão para todo o catálogo de endpoints.
- **Extração efetiva para SPM no target iOS principal**:
  - Scaffold criado; falta conectar os pacotes ao projeto Xcode e mover código concreto de Core/DesignSystem para os módulos.
- **Snapshot visual com baseline versionado**:
  - Existem testes de render básicos; ainda pode evoluir para snapshot com baseline de referência por componente.

## Classificação de aderência
- **Aderência estimada ao blueprint**: **alta (≈ 85–90%)**
- **Pontos mais fortes**: fluxo arquitetural, DI explícita, estado padronizado, MVVM-C por feature prioritária e base de qualidade.
