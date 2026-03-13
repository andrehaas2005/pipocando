# Blueprint Arquitetural — Pipocando (MVVM-C Profissional)

## 1) Objetivo
Este blueprint define uma evolução incremental para tornar o projeto **MVVM-C**, escalável, testável e pronto para crescimento de produto.

Metas principais:
- Padronizar arquitetura por camadas.
- Reduzir acoplamento entre UI, networking e navegação.
- Melhorar testabilidade e previsibilidade de estado.
- Estruturar Design System reutilizável.
- Habilitar modularização progressiva (sem big-bang rewrite).

---

## 2) Princípios de arquitetura
1. **Single Responsibility** por tipo (View, ViewModel, Coordinator, Service, Repository).
2. **Dependency Inversion** (ViewModels dependem de protocolos, não de concretos/singletons).
3. **Navigation ownership** no Coordinator (ViewController não decide fluxo).
4. **Feature isolation** (cada feature com contratos próprios).
5. **State-driven UI** (estado explícito e previsível).
6. **Testability first** (injeção de dependências e contratos claros).

---

## 3) Arquitetura-alvo (visão em camadas)

### 3.1 Camadas
- **App Layer**
  - `AppCoordinator`, `SceneDelegate`, composição de dependências.
- **Presentation Layer**
  - `ViewController` + `ViewModel` + `Coordinator` por feature.
- **Domain Layer**
  - `UseCases`, `Entities`, `Repository Protocols`.
- **Data Layer**
  - `Repositories`, `RemoteDataSource`, `LocalDataSource`, `Mappers`.
- **Core/Platform Layer**
  - Networking, Logging, Config, Error Handling, Utilidades comuns.
- **Design System Layer**
  - Tokens + componentes UI + temas.

### 3.2 Fluxo recomendado
`View -> ViewModel -> UseCase -> Repository -> DataSource -> Network`

Navegação:
`ViewModel -> Coordinator (via protocolo de rota)`

---

## 4) Estrutura de pastas sugerida (monorepo inicial)

```text
Pipocando/
  App/
    AppDelegate.swift
    SceneDelegate.swift
    AppCoordinator.swift
    DependencyContainer.swift

  Core/
    Networking/
    Configuration/
    Logging/
    Extensions/
    SharedTypes/

  DesignSystem/
    Tokens/
      Colors.swift
      Typography.swift
      Spacing.swift
      Radius.swift
    Components/
      Buttons/
      Cards/
      Cells/
    Theme/
      AppTheme.swift

  Domain/
    Entities/
    UseCases/
      Movies/
      Series/
    Repositories/

  Data/
    Repositories/
      MoviesRepositoryImpl.swift
      SeriesRepositoryImpl.swift
    DataSources/
      Remote/
      Local/
    DTO/
    Mappers/

  Features/
    Home/
      Presentation/
        View/
        ViewModel/
        Coordinator/
      Domain/
      Data/
    Details/
    Calendar/
    Favorites/
    Profile/

  Resources/
  SupportingFiles/

docs/
  ARCHITECTURE_BLUEPRINT_MVVM-C.md
```

---

## 5) Contratos-chave (padrão recomendado)

### 5.1 Coordinator
- Cada feature expõe `FeatureCoordinator`.
- Coordinator pai gerencia ciclo de vida de children (`add/remove`).
- ViewModel não importa UIKit: comunica rota via protocolo.

### 5.2 ViewModel
- Inputs/Outputs explícitos (eventos e estado).
- Sem dependência de classes concretas de serviço.
- Sem acesso direto a singleton de rede.

### 5.3 Data
- `Repository` abstrai origem dos dados.
- `UseCase` concentra regra de negócio (ex.: ordenação, filtro, fallback cache).

---

## 6) Estado e concorrência

### 6.1 Padrão de estado
Criar estado por feature:
- `idle`
- `loading`
- `loaded(Data)`
- `error(AppError)`

### 6.2 Concorrência
- Priorizar `async/await` internamente.
- Manter adapters de completion apenas para compatibilidade temporária.
- Garantir atualização de UI em main thread (`@MainActor` em ViewModel quando aplicável).

---

## 7) Design System (nível profissional)

### 7.1 Tokens obrigatórios
- Cor, tipografia, espaçamento, raio, opacidade, elevação.

### 7.2 Componentes base
- `PrimaryButton`, `SecondaryButton`, `TagView`, `PosterCard`, `RatingBadge`, `LoadingView`, `ErrorView`.

### 7.3 Regras
- Feature não define cor/font hardcoded.
- Reuso via componentes/tokens.
- Snapshot tests para componentes críticos.

---

## 8) Modularização (estratégia incremental)

### Fase 1 — sem quebrar app
- Organizar estrutura por camadas e contratos no mesmo target.
- Introduzir `DependencyContainer`.

### Fase 2 — Swift Packages internos
- Extrair `Core` e `DesignSystem` para SPM local.

### Fase 3 — feature modules
- Extrair `Home`, `Details`, `Calendar` em módulos independentes.

### Fase 4 — otimização
- Build parallelizado, boundary tests e governança de dependências.

---

## 9) Qualidade, segurança e observabilidade

### 9.1 Segurança
- Remover secrets versionados (API key) do repositório.
- Usar `.xcconfig`, variáveis de ambiente e segredo por pipeline.

### 9.2 Qualidade
- SwiftLint + SwiftFormat + regras CI.
- Cobertura mínima por módulo.
- Testes: unitário, integração de data layer e snapshot de UI.

### 9.3 Observabilidade
- Logger estruturado por categoria (network, navigation, ui-state).
- Erros normalizados (`AppError`) com mapeamento de domínio.

---

## 10) Plano de execução (90 dias)

### Sprint 1–2
- DependencyContainer + contratos Coordinator/ViewModel.
- Eliminar singletons em ViewModels.
- Consolidar Movie/Serie services em repository protocol.

### Sprint 3–4
- Introduzir UseCases críticos (Home feed, Details).
- Padronizar state machine por feature.
- Criar tokens de design system (Typography/Spacing).

### Sprint 5–6
- Extrair Core + DesignSystem para SPM local.
- Implementar CI (lint + tests + build).

### Sprint 7–8
- Extrair 1ª feature module (`Home`).
- Snapshot tests e métricas de qualidade.

---

## 11) Definition of Done (arquitetura)
Uma feature só é “done” se:
- Usa Coordinator para navegação.
- ViewModel depende de protocolo.
- Possui estado explícito (`loading/loaded/error`).
- Inclui testes unitários mínimos.
- Não usa segredo hardcoded.
- Reutiliza tokens/componentes do Design System.

---

## 12) Próximo passo prático imediato
1. Criar `DependencyContainer` no `App`.
2. Definir protocolos de repositório `MoviesRepository` e `SeriesRepository`.
3. Migrar `Home` para fluxo `ViewModel -> UseCase -> Repository`.
4. Adicionar `AppError` único e mapear erros de rede.
5. Criar `Typography` e `Spacing` no Design System.
