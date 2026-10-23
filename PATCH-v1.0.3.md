# GorillasEX v1.0.3 — patch de mira por jogador e protecoes de audio

- Corrige o compartilhamento indevido de angulo e potencia entre humano e IA.
- Cada jogador tem seu ultimo angulo e potencia preservados na rodada; na nova rodada os valores reiniciam em 45/65.
- Insere verificacao defensiva para amostragem e duracao de audio iguais a zero.

**Importante:** a origem da excecao "Division by zero" nao foi comprovada. Este patch contem protecoes na rotina de audio, mas nao deve ser considerado a correcao definitiva da falha sem a localizacao exata e reproducao.

Base: codigo-fonte v1.0.0 com patches v1.0.1 e v1.0.2 aplicados.

Extraia na pasta PAI de `GorillasEX`, substituindo os arquivos.
