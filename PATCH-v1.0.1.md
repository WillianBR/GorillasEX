# GorillasEX — patch v1.0.1

Corrige nove declaracoes `FUNCTION Nome(...) AS Tipo` incompativeis com QB64-PE, sem usar sufixos de tipo nos nomes das funcoes.

## Instalacao

Extraia o ZIP **sobre a pasta que contem GorillasEX**, mantendo os caminhos e substituindo os arquivos existentes. Nao extraia dentro de `GorillasEX`, sob pena de criar uma pasta duplicada.

Arquivos alterados:

- `src/gorillas.bas`: inclui `DEFINT I`, `DEFLNG B, E, F, J, P`, `DEFDBL R` e `DEFSTR S`.
- `src/graphics/renderer.bi`: remove `AS Tipo` do retorno das funcoes.
- `src/graphics/buildings.bi`: mesma correcao.
- `src/storage/ranking.bi`: mesma correcao e renomeia `JsonName` para `StringJsonName` para obter retorno STRING sem sufixo.

Os parametros e variaveis seguem explicitamente tipados com `AS`.

**Advertencia**: patch de analise estatica; nao foi testado com um compilador QB64-PE instalado. Podem existir outros erros independentes.
