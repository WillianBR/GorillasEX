# GorillasEX — Inventário de arquivos

> Referência: pacote de código-fonte GorillasEX v1.0.6, acrescido dos dois arquivos desta entrega.
> Os diretórios `.git/` e os binários gerados em `bin/` não fazem parte do inventário do código-fonte.

## Visão geral

| Diretório | Finalidade |
| :--- | :--- |
| `GorillasEX/` | Raiz do projeto; documentação e distribuição do fonte. |
| `.vscode/` | Configuração de desenvolvimento no Visual Studio Code. |
| `src/` | Código-fonte QB64-PE e recursos de execução. |
| `bin/` | Executável e distribuição binária; pasta de saída da compilação. |
| `docs/` | Planejamento e documentação técnica. |
| `original/` | Referências históricas e créditos. |
| `tests/` | Planejamento de testes. |

## Arquivos por pasta

### `GorillasEX/`

| Arquivo | Finalidade |
| :--- | :--- |
| `.gitignore` | Regras do Git para ignorar binários, arquivos temporários e dados locais. |
| `GorillasEX.FILES.md` | Inventário de arquivos por pasta com descrição de suas finalidades. |
| `Package-GorillasEX.bat` | Cria ZIP do código-fonte preservando a pasta raiz e excluindo .git e bin. |
| `PATCH-v1.0.1.md` | Notas de correção de declarações de funções e tipos de retorno. |
| `PATCH-v1.0.3.md` | Notas sobre a separação dos parâmetros de mira de cada jogador e ajustes de áudio. |
| `PATCH-v1.0.5.md` | Registro das melhorias na cidade, animação de vitória e ajuda. |
| `PATCH-v1.0.6.md` | Registro da revisão da banana, confirmação de saída e empacotamento. |
| `README.md` | Apresentação, instruções de compilação, recursos, limitações e créditos. |

### `.vscode`

| Arquivo | Finalidade |
| :--- | :--- |
| `launch.json` | Configuração de execução do jogo pelo VSCode. |
| `settings.json` | Associações de extensões BASIC e preferências locais do editor. |
| `tasks.json` | Tarefas de compilação, execução, verificação sintática e empacotamento. |

### `src`

| Arquivo | Finalidade |
| :--- | :--- |
| `gorillas.bas` | Ponto de entrada: metadados, inicialização, loop principal, renderização e includes. |

### `src/core`

| Arquivo | Finalidade |
| :--- | :--- |
| `game.bi` | Regras, início de partidas e rodadas, turnos, disparos e apuração de vencedores. |
| `physics.bi` | Movimento dos projéteis, colisões físicas, gravidade e atualização por passo fixo. |
| `types.bi` | Constantes, tipos e variáveis compartilhadas do estado do jogo. |

### `src/graphics`

| Arquivo | Finalidade |
| :--- | :--- |
| `buildings.bi` | Geração procedural da cidade, consulta ao terreno e crateras de explosões. |
| `renderer.bi` | Conversão de coordenadas, primitivas de desenho e renderização do cenário. |
| `sprites.bi` | Desenho procedural dos gorilas e da banana. |

### `src/audio`

| Arquivo | Finalidade |
| :--- | :--- |
| `sound.bi` | Síntese e reprodução de efeitos sonoros por geração de amostras PCM. |

### `src/input`

| Arquivo | Finalidade |
| :--- | :--- |
| `input.bi` | Leitura de teclado e mouse, interação com menus e confirmação de saída. |

### `src/ui`

| Arquivo | Finalidade |
| :--- | :--- |
| `screens.bi` | Telas de menu, jogo, ranking, ajuda, edição de nomes e confirmação de saída. |

### `src/storage`

| Arquivo | Finalidade |
| :--- | :--- |
| `ranking.bi` | Busca e atualização de registros; leitura, gravação e ordenação do ranking JSON. |

### `src/platform`

| Arquivo | Finalidade |
| :--- | :--- |
| `platform.bi` | Inicialização/redimensionamento de vídeo e seleção da pasta de dados. |

### `src/assets/icons`

| Arquivo | Finalidade |
| :--- | :--- |
| `GorillasEX.ico` | Ícone multirresolução incorporado ao executável Windows. |
| `GorillasEX.png` | Arte PNG utilizada na identidade visual e na tela de ajuda. |

### `bin`

| Arquivo | Finalidade |
| :--- | :--- |
| `Package-GorillasEX-bin.bat` | Calcula SHA-256 do EXE e reúne GorillasEX.exe* em GorillasEX-bin.zip. |

### `docs`

| Arquivo | Finalidade |
| :--- | :--- |
| `ROADMAP.md` | Roteiro das funcionalidades previstas e próximas melhorias. |

### `original`

| Arquivo | Finalidade |
| :--- | :--- |
| `README.md` | Referências e atribuições às versões históricas do Gorillas. |

### `tests`

| Arquivo | Finalidade |
| :--- | :--- |
| `README.md` | Orientações para verificações e cenários de teste do projeto. |

## Observações de manutenção

- **Empacotamento do fonte:** execute `Package-GorillasEX.bat` na raiz. O ZIP do fonte exclui `.git/` e `bin/`.
- **Empacotamento do executável:** depois de compilar `bin/GorillasEX.exe`, execute `bin/Package-GorillasEX-bin.bat`.
- **Hash:** o arquivo `bin/GorillasEX.exe.sha256` contém SHA-256 em hexadecimal, seguido de `*GorillasEX.exe`.
- **Conteúdo do ZIP binário:** todos os arquivos regulares cujo nome começa por `GorillasEX.exe` (incluindo o hash e eventuais símbolos `GorillasEX.exe.dbg`).
- **Nota de caminhos:** no pacote inspecionado, os ícones estão em `src/assets/icons/`, não em `assets/icons/` na raiz.
- **Atualização deste inventário:** a lista descreve os arquivos presentes no pacote analisado; novos arquivos adicionados ao projeto deverão ser documentados aqui.
