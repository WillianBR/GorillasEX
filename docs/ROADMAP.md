# Roadmap tecnico

## Entrega 1.0.0

Fonte BASIC dividido em subsistemas, janela 32 bits, jogo de dois jogadores e contra IA simples, crateras e queda dos gorilas, sintese de efeitos, persistencia JSON.

## Proxima etapa: estabilizacao

1. Compilar com QB64-PE Windows/Linux/macOS; corrigir diagnosticos exatos e arquivar logs de build.
2. Testes manuais para som, F11, teclado especial, mouse e DPI 125-200%.
3. Adicionar scroll e paginacao reais ao ranking (sem limite visual de 20).
4. Cadastro/renomeacao, configuracoes e IA balistica de tres dificuldades.
5. Preservar cidade ao redimensionar a janela; suportar aspect ratio ultrawide sem alterar combate.
6. Integrar replay e importador historico de ranking `.LGE`.
7. Testes deterministas automatizados com harness sem interface.
8. Otimizar o cache da cena e redesenho de crateras e edifícios.
9. Modos classico e expandido mais refinados; ambientacao urbana e animacoes dos espectadores.
