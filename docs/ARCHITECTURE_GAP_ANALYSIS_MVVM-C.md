# Gap Analysis — Blueprint MVVM-C vs Estado atual do projeto

## Escopo avaliado
- Documento alvo: `docs/ARCHITECTURE_BLUEPRINT_MVVM-C.md`.
- Código atual no target principal `Pipocando`.

## Resumo executivo
O projeto já avançou em fundamentos de MVVM-C (coordinators por fluxo principal, `AppDependencyContainer`, ViewModels com estado observável e introdução de alguns UseCases/Repositories). Porém, ainda faltam itens estruturais para atingir o blueprint “profissional”: separação real por camadas/módulos, domínio desacoplado de features, padronização de estado/concorrência, design system completo e governança de qualidade/segurança em CI.

## O que já existe (aderência parcial)
1. **Coordinator raiz + fluxo por feature**: `AppCoordinator` compõe e inicia `HomeCoordinator`, `WatchlistCoordinator`, `CalendarCoordinator`.
2. **Container de dependências**: `AppDependencyContainer` fabrica UseCases e injeta serviços.
3. **UseCase/Repository introduzidos**: Home, Calendar e Details possuem protocolos de UseCase e Repository.
4. **Estado explícito em ViewModels principais**: exemplos com `idle/loading/loaded/error`.
5. **Tokens iniciais de Design System**: `Spacing`, `Typography` e paleta `Color`.

## Principais lacunas para cumprir o blueprint

### 1) Arquitetura por camadas ainda não está consolidada
- **Gap**: Repositórios e UseCases estão definidos dentro de arquivos de ViewModel de feature, em vez de camadas `Domain/` e `Data/` dedicadas.
- **Impacto**: dificulta escalabilidade, reutilização e testes de regra de negócio independentes da UI.
- **Ação sugerida**:
  - Extrair protocolos para `Domain/Repositories`.
  - Extrair UseCases para `Domain/UseCases`.
  - Extrair implementações para `Data/Repositories` + `DataSources` + `Mappers`.

### 2) Inversão de dependência ainda incompleta
- **Gap**: Ainda há singletons (`MovieService.shared`, `SerieService.shared`) como defaults do container.
- **Impacto**: reduz previsibilidade em testes e favorece acoplamento implícito.
- **Ação sugerida**:
  - Remover defaults com singleton no composition root de produção.
  - Injetar concretos explicitamente no bootstrap (`SceneDelegate/AppCoordinator`).

### 3) Fluxo `View -> ViewModel -> UseCase -> Repository` não é uniforme
- **Gap**: `PosterViewModel` e `CarrosselViewModel` falam direto com `MovieServiceProtocol`, pulando UseCase/Repository.
- **Impacto**: heterogeneidade arquitetural e lógica dispersa.
- **Ação sugerida**:
  - Criar UseCases específicos (ex. `FetchTrendingMoviesUseCase`) e padronizar a cadeia em todas as features.

### 4) Estado e concorrência precisam de padronização global
- **Gap**: Existem estados explícitos em parte das features, porém com variações de implementação e forte uso de APIs em completion callbacks.
- **Impacto**: inconsistência de fluxo e maior custo cognitivo entre features.
- **Ação sugerida**:
  - Definir convenção única de `FeatureState`.
  - Migrar contratos internos para `async/await`, mantendo adapters de completion apenas como transição.

### 5) Domain model e boundaries ainda misturados com UI/infra
- **Gap**: `Model/` centraliza DTOs/entidades sem separação clara de domínio vs transporte.
- **Impacto**: dificulta evolução de contrato de API sem impacto na camada de apresentação.
- **Ação sugerida**:
  - Introduzir DTOs em `Data/DTO` + mappers para entidades de domínio.

### 6) Design System ainda parcial frente ao blueprint
- **Gap**: faltam tokens completos (raio/opacidade/elevação) e componentes base definidos no blueprint (PrimaryButton, SecondaryButton, TagView, RatingBadge, LoadingView, ErrorView).
- **Impacto**: risco de estilos hardcoded nas features e baixa consistência visual.
- **Ação sugerida**:
  - Completar tokens e catálogo mínimo de componentes reutilizáveis.

### 7) Segurança de configuração ainda pendente
- **Gap**: `Config.plist` versiona `APIKey` em texto.
- **Impacto**: exposição de segredo e não conformidade com a diretriz de segurança.
- **Ação sugerida**:
  - Remover segredo do repositório.
  - Migrar para `.xcconfig`/env por pipeline e placeholders locais ignorados por git.

### 8) Qualidade e observabilidade ainda abaixo do alvo
- **Gap**: não há evidência de CI com lint/format/build/test, nem snapshot tests de UI, nem logger estruturado por categoria.
- **Impacto**: menor governança técnica e feedback tardio de regressões.
- **Ação sugerida**:
  - Adicionar workflow CI (build + testes + SwiftLint/SwiftFormat).
  - Introduzir snapshot tests para componentes críticos.
  - Criar logger central com categorias (`network`, `navigation`, `ui-state`).

### 9) Modularização (SPM/features) ainda não iniciada
- **Gap**: estrutura ainda em target único, sem extração de `Core` e `DesignSystem` para SPM e sem módulos por feature.
- **Impacto**: builds mais lentos e fronteiras de dependência frágeis.
- **Ação sugerida**:
  - Iniciar Fase 2 do blueprint com pacote local para `Core` e `DesignSystem`.

## Backlog recomendado (priorizado)
1. **Arquitetura base**: extrair `Domain` e `Data` para fora dos ViewModels (Home/Calendar/Details primeiro).
2. **Dependências**: eliminar singletons dos defaults e centralizar composição explícita.
3. **Padronização de fluxo**: atualizar Poster/Carrossel para UseCase + Repository.
4. **Segurança**: retirar API key do repo e configurar pipeline/env.
5. **Qualidade**: CI com lint/format/test/build + cobertura mínima.
6. **Design System**: completar tokens e componentes base.
7. **Modularização incremental**: SPM local para `Core`/`DesignSystem`.

## Classificação geral de aderência
- **Aderência atual ao blueprint**: **média-baixa (aprox. 40–50%)**.
- **Eixo mais avançado**: coordenação de navegação e início de DI.
- **Eixos mais críticos**: boundaries de camadas, segurança de secrets e governança de qualidade/CI.
