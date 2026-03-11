# Issues prontas — melhoria de qualidade do código

## 1) [Refactor] Corrigir erros de digitação em nomes utilitários

**Título sugerido**  
`[Refactor] Padronizar nomes em Utilits.swift (typos em classe e parâmetros)`

**Descrição**  
O arquivo `Utilits.swift` expõe nomes com erro de digitação em identificadores públicos, o que prejudica legibilidade, busca por símbolos e consistência da API interna.

Problemas identificados:
- `Utilits` (classe) — provável typo de `Utilities`.
- `rightMargein`, `leftMargein`, `topMargein`, `bottonMargein` — typos em parâmetros.

**Escopo**
- Renomear classe e parâmetros para nomes corretos.
- Atualizar todos os pontos de chamada impactados.
- Garantir que não haja regressão de build.

**Critérios de aceite**
- [ ] Build compila sem erros após renomeações.
- [ ] Não existem ocorrências dos nomes antigos no código (`Utilits|Margein|botton`).
- [ ] API resultante mantém comportamento atual.

**Prioridade**: Média  
**Tipo**: Refactor / Code Quality

---

## 2) [Bug] Implementar métodos vazios de busca de filmes

**Título sugerido**  
`[Bug] Implementar fetchPopularMovies/fetchTopRatedMovies/fetchUpcomingMovies em MovieService`

**Descrição**  
`MovieService` contém três métodos públicos vazios:
- `fetchPopularMovies`
- `fetchTopRatedMovies`
- `fetchUpcomingMovies`

Atualmente eles não disparam request nem chamam `completion`, podendo travar fluxos que dependem de retorno assíncrono.

**Escopo**
- Implementar os três métodos usando `APIMovieRequest` com as rotas correspondentes:
  - `.popular`
  - `.topRated`
  - `.upcoming`
- Reaproveitar `fetchWithAsync` para padronizar sucesso/erro.
- Garantir chamada de `completion` em todos os caminhos.

**Critérios de aceite**
- [ ] Os três métodos executam request corretamente.
- [ ] `completion` é chamado sempre (sucesso e falha).
- [ ] Sem duplicação desnecessária de lógica assíncrona.

**Prioridade**: Alta  
**Tipo**: Bug

---

## 3) [Docs] Alinhar comentário/documentação com endpoints reais

**Título sugerido**  
`[Docs] Corrigir discrepância entre comentário de endpoints e implementação em Configuration`

**Descrição**  
Há discrepância entre código e documentação local em `Configuration.swift`:
- `Endpoints.genres` retorna string vazia (`""`).
- Comentário no final do arquivo lista endpoints de TV, mas não documenta claramente o estado real dos endpoints expostos.

Isso pode induzir uso incorreto e aumentar chance de erro em futuras integrações.

**Escopo**
- Definir comportamento explícito de `Endpoints.genres` (endpoint válido ou remoção se não utilizado).
- Atualizar bloco de comentário para refletir exatamente o que a implementação suporta.
- Opcional: mover documentação para local único (README/DocC) para evitar drift.

**Critérios de aceite**
- [ ] Não existe endpoint público “placeholder” sem justificativa.
- [ ] Comentários/documentação correspondem ao comportamento real do código.
- [ ] Revisão aprovada sem ambiguidades sobre endpoints disponíveis.

**Prioridade**: Média  
**Tipo**: Documentation

---

## 4) [Tests] Tornar teste de configuração realmente executável

**Título sugerido**  
`[Tests] Corrigir nome de teste em Configuration_Tests e fortalecer validações`

**Descrição**  
O método `returnEnumString()` não segue convenção do XCTest (`test...`) e não é executado automaticamente pela suíte. Além disso, há um teste de performance genérico sem validação funcional útil.

**Escopo**
- Renomear `returnEnumString()` para `test...` com nome descritivo.
- Reforçar asserts para validar configuração mínima esperada (não nulo/não vazio/formato).
- Avaliar remoção ou substituição de `testPerformanceExample()` por teste funcional.

**Critérios de aceite**
- [ ] Teste de configuração roda automaticamente na suíte.
- [ ] Falhas reais de configuração quebram o teste de forma determinística.
- [ ] Suíte de testes fica mais relevante e menos “boilerplate”.

**Prioridade**: Média  
**Tipo**: Test Improvement
