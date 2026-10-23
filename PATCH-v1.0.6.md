# GorillasEX v1.0.6 — banana e confirmacao de saida

- O desenho da banana agora usa um arco amarelo preenchido com pontas castanhas e rotacao continua.
- O clique em X e a opcao SAIR usam o mesmo dialogo multiplataforma (Sim/Nao).
- A selecao padrao e NAO; ESC cancela; setas/TAB, ENTER e mouse sao aceitos.
- A saida confirmada passa pelo fluxo existente de gravacao do ranking e limpeza de recursos.
- O gerador de ZIP invoca `%SystemRoot%\System32\tar.exe` explicitamente e `--format=zip`, sem depender do PATH.

## Testes manuais recomendados

1. Executar tiro e observar se a banana curva permanece reconhecivel durante a rotacao.
2. Abrir o dialogo pelo X; cancelar e garantir que a partida continua.
3. Abrir pelo menu SAIR; confirmar e verificar encerramento normal.
4. Testar clique em cada botao, Enter, Escape e navegacao por setas.

Esta revisao foi analisada estaticamente e **nao foi compilada com QB64-PE** neste ambiente.
