# Gap Analysis — Blueprint MVVM-C vs estado real do projeto

## Objetivo desta análise
Avaliar, de forma prática, o quanto o estado atual do repositório está aderente ao blueprint em `docs/ARCHITECTURE_BLUEPRINT_MVVM-C.md`.

---

## Resumo executivo
- **Aderência geral estimada**: **~80%**.
- **Projeto já demonstra base profissional**: sim, principalmente por possuir MVVM-C em partes críticas, DI via container, camada de domínio com protocolos e CI com lint/format/build/test.
- **Ainda não está em 100% do blueprint**: faltam consolidações de modularização real (SPM conectado), padronização completa de feature boundaries e evolução total do Design System/tokens em toda a UI.

---

## O que já está aderente ao blueprint

1. **Fluxo arquitetural principal implementado em features-chave**
   - Home/Details/Calendar já usam cadeia com UseCase + Repository + RemoteDataSource e ViewModel orientado a estado.

2. **Dependency Injection e composição no app**
   - Existe `AppDependencyContainer` com construção de use cases/repositories por protocolo, reduzindo acoplamento direto em ViewModel.

3. **Coordinator como dono da navegação principal**
   - AppCoordinator organiza o fluxo por tabs com coordinators de feature.

4. **Estado explícito em várias features**
   - Calendar, Details, Watchlist e Profile possuem enums de estado (`idle/loading/loaded/error`).

5. **Qualidade mínima automatizada**
   - Workflow de CI com SwiftLint, SwiftFormat, build e testes.

6. **Fundação de Design System e modularização iniciada**
   - Tokens/componentes base existem.
   - Pacotes `Packages/PipocandoCore` e `Packages/PipocandoDesignSystem` já foram criados como scaffold.

---

## O que ainda falta para chegar a 100% do blueprint

1. **SPM ainda não está efetivamente integrado ao target principal**
   - Os pacotes locais existem, mas não há referência deles no `project.pbxproj`.
   - Para 100%: conectar os packages ao projeto e mover código real (Core/DesignSystem) para os módulos.

2. **Estrutura de features ainda heterogênea**
   - Algumas pastas de feature (ex.: `Actors`, `Carrossel`, `PosterMovies`) não seguem a mesma tríade `View/ViewModel/Coordinator` adotada nas features principais.
   - Para 100%: padronizar todos os blocos navegáveis como features MVVM-C ou reclassificar oficialmente os que são apenas componentes de UI.

3. **Uso incompleto de Design System/tokens na UI**
   - Ainda há diversos `UIFont.systemFont(...)` e `UIColor(...)`/hex diretamente em telas/componentes.
   - Para 100%: eliminar estilos hardcoded de feature e centralizar tokens/componentes.

4. **Separação Domain/Data ainda pode evoluir para cobertura total**
   - Já existem repositórios e data sources, mas o blueprint prevê evolução ampla com entidades, DTO e mappers para todo o catálogo.
   - Para 100%: formalizar e aplicar o padrão em todos os fluxos/endpoints.

5. **Convergência da nomenclatura estrutural**
   - O blueprint sugere camadas `App/Core/DesignSystem/Domain/Data/Features`; o projeto ainda mantém diretórios legados em paralelo (`Model`, `Service`, `Network`, `Common`).
   - Para 100%: reduzir duplicidade conceitual e consolidar nomenclatura por camada.

6. **DoD por feature ainda precisa ser tratado como gate formal**
   - Apesar de já haver testes e estados em partes do app, o critério completo de DoD (incluindo padronização total de tokens/snapshots por componentes críticos) ainda não parece ser gate obrigatório para toda feature nova.

---

## O projeto pode ser classificado como bem estruturado/profissional hoje?

**Sim, com ressalvas.**

Classificação sugerida:
- **Estrutura e organização**: **boa/alta**.
- **Maturidade arquitetural**: **boa, em transição para alta**.
- **Profissionalismo de engenharia**: **bom**, com sinais claros de governança (CI, lint/format, contratos por protocolo, composição por coordinator).

Ou seja: não é “arquitetura improvisada”; é um projeto com direção técnica correta e evolução já em andamento. O principal ponto é **fechar consistência** para não coexistirem padrões novos e legados por muito tempo.

---

## Comentários recomendados para outro desenvolvedor (code review técnico)

1. **Elogiar o direcionamento arquitetural já aplicado**
   - MVVM-C, DI por container, use cases e CI estão no caminho de produto escalável.

2. **Pedir padronização final de fronteiras por feature**
   - Definir oficialmente o que é feature navegável vs componente de UI reutilizável.

3. **Cobrar “token-first UI”**
   - Evitar qualquer hardcode visual novo; priorizar tokens/componentes do Design System.

4. **Priorizar integração real dos SPMs locais**
   - Isso é passo essencial para isolamento de camadas e velocidade de build/manutenção.

5. **Consolidar migração gradual sem regressão de padrão**
   - Toda mudança nova deve seguir o DoD arquitetural para evitar débito técnico incremental.

6. **Formalizar métrica de aderência contínua**
   - Checklist em PR template (Coordinator, protocolo em ViewModel, state explícito, testes, sem hardcoded visual e sem segredo).

---

## Backlog objetivo (curto prazo)

1. Integrar `PipocandoCore` e `PipocandoDesignSystem` no target iOS.
2. Migrar primeiro bloco concreto para package (ex.: tokens e logger).
3. Normalizar subpastas de Features (decisão: feature completa vs componente).
4. Remover hardcodes visuais mais recorrentes nas telas principais.
5. Criar checklist de DoD arquitetural no template de PR.
