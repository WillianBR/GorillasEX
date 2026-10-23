' Interface simples, inteiramente desenhada sem assets externos.
SUB DrawMenu
    DIM MenuItem AS STRING, I AS LONG, Fore AS _UNSIGNED LONG
    _PUTIMAGE , SceneImage
    BoxWorld 135, 70, WorldWidth - 135, 605, _RGB32(18, 25, 49)
    TextWorld 195, 95, "G O R I L L A S E X", _RGB32(255, 216, 66)
    TextWorld 195, 135, "v" + GameVersion + "  |  Retro Artillery / 32-bit", _RGB32(180, 207, 238)
    FOR I = 1 TO 8
        SELECT CASE I
            CASE 1: MenuItem = "JOGAR - dois jogadores"
            CASE 2: MenuItem = "JOGAR - contra computador"
            CASE 3: MenuItem = "NOME DO PLAYER 1"
            CASE 4: MenuItem = "NOME DO PLAYER 2"
            CASE 5: MenuItem = "RANKING JSON"
            CASE 6: MenuItem = "AJUDA E CONTROLES"
            CASE 7: MenuItem = "ALTERAR RESOLUCAO"
            CASE 8: MenuItem = "SAIR"
        END SELECT
        Fore = _RGB32(218, 231, 245)
        IF SelectedMenu = I THEN
            Fore = _RGB32(255, 220, 100)
            BoxWorld 173, 208 + (I - 1) * 43, WorldWidth - 173, 245 + (I - 1) * 43, _RGB32(43, 62, 91)
        END IF
        TextWorld 195, 218 + (I - 1) * 43, MenuItem, Fore
    NEXT I
    TextWorld 185, 540, "Setas + ENTER ou mouse  |  F11: tela cheia  |  M: audio", _RGB32(149, 190, 214)
    TextWorld 185, 575, "Resolucao: " + LTRIM$(STR$(ScreenWidth)) + " x " + LTRIM$(STR$(ScreenHeight)), _RGB32(149, 190, 214)
END SUB

SUB DrawGame
    DIM I AS LONG, Caption AS STRING
    _PUTIMAGE , SceneImage
    FOR I = 1 TO 2
        DrawGorilla I
    NEXT I
    DrawBanana
    BoxWorld 0, 0, WorldWidth, 69, _RGB32(18, 26, 48)
    TextWorld 15, 9, Gorillas(1).Name + ":" + LTRIM$(STR$(Gorillas(1).Wins)), _RGB32(253, 221, 84)
    TextWorld WorldWidth - 235, 9, Gorillas(2).Name + ":" + LTRIM$(STR$(Gorillas(2).Wins)), _RGB32(253, 221, 84)
    Caption = "Round " + LTRIM$(STR$(RoundNumber)) + "/" + LTRIM$(STR$(RoundLimit))
    TextWorld WorldWidth / 2 - 70, 8, Caption, _RGB32(235, 240, 255)
    Caption = "Wind " + LTRIM$(STR$(INT(Wind))) + " | Angle " + LTRIM$(STR$(INT(AimAngle)))
    Caption = Caption + " | Power " + LTRIM$(STR$(INT(AimPower)))
    TextWorld WorldWidth / 2 - 175, 35, Caption, _RGB32(180, 211, 237)
    BoxWorld 0, 634, WorldWidth, 675, _RGB32(18, 26, 48)
    IF RoundFinished <> 0 OR GameTime < StatusUntil THEN
        TextWorld 18, 647, StatusText, _RGB32(250, 221, 107)
    ELSE
        TextWorld 18, 647, "Vez: " + Gorillas(CurrentPlayer).Name + "  |  ESC: menu", _RGB32(237, 241, 247)
    END IF
    IF ShowDebug <> 0 THEN
        TextWorld 16, 80, "Seed " + LTRIM$(STR$(CitySeed)) + " | Native " + LTRIM$(STR$(ScreenWidth)) + "x" + LTRIM$(STR$(ScreenHeight)), _RGB32(255, 255, 255)
    END IF
END SUB

SUB DrawRanking
    DIM I AS LONG, FromRecord AS LONG, UntilRecord AS LONG, LineText AS STRING
    CLS , _RGB32(20, 32, 55)
    TextWorld 70, 45, "GORILLASEX - RANKING", _RGB32(255, 218, 86)
    TextWorld 70, 88, "Pos  Jogador                  Rodadas  Vitorias  Derrotas  Lanc.  Acertos", _RGB32(202, 218, 241)
    FromRecord = RankingPage * 20 + 1
    UntilRecord = FromRecord + 19
    IF UntilRecord > RecordCount THEN UntilRecord = RecordCount
    FOR I = FromRecord TO UntilRecord
        LineText = RIGHT$("   " + LTRIM$(STR$(I)), 3) + "  "
        LineText = LineText + LEFT$(Records(I).Name + SPACE$(24), 24)
        LineText = LineText + RIGHT$(SPACE$(8) + LTRIM$(STR$(Records(I).Matches)), 8)
        LineText = LineText + RIGHT$(SPACE$(10) + LTRIM$(STR$(Records(I).Wins)), 10)
        LineText = LineText + RIGHT$(SPACE$(10) + LTRIM$(STR$(Records(I).Losses)), 10)
        LineText = LineText + RIGHT$(SPACE$(8) + LTRIM$(STR$(Records(I).Throws)), 8)
        LineText = LineText + RIGHT$(SPACE$(8) + LTRIM$(STR$(Records(I).Hits)), 8)
        TextWorld 70, 100 + (I - FromRecord + 1) * 23, LineText, _RGB32(224, 231, 243)
    NEXT I
    TextWorld 70, 610, "Registros: " + LTRIM$(STR$(RecordCount)) + " | Pagina " + LTRIM$(STR$(RankingPage + 1)) + " | Esquerda/Direita troca pagina", _RGB32(245, 201, 116)
    TextWorld 70, 642, "ENTER / clique / ESC: voltar", _RGB32(175, 200, 230)
END SUB

SUB DrawHelp
    CLS , _RGB32(20, 32, 55)
    TextWorld 70, 58, "GORILLASEX - CONTROLES", _RGB32(255, 217, 85)
    TextWorld 70, 130, "Seta PARA CIMA / BAIXO: mudar angulo", _RGB32(220, 236, 246)
    TextWorld 70, 172, "Seta ESQUERDA / DIREITA: mudar potencia", _RGB32(220, 236, 246)
    TextWorld 70, 214, "ESPACO ou clique: arremessar banana", _RGB32(220, 236, 246)
    TextWorld 70, 256, "ENTER: proxima rodada depois da vitoria", _RGB32(220, 236, 246)
    TextWorld 70, 298, "ESC: voltar ao menu", _RGB32(220, 236, 246)
    TextWorld 70, 340, "M: ativar/desativar sons sintetizados", _RGB32(220, 236, 246)
    TextWorld 70, 382, "F11: alternar tela cheia", _RGB32(220, 236, 246)
    TextWorld 70, 424, "F3: mostrar dados de diagnostico", _RGB32(220, 236, 246)
    TextWorld 70, 490, "Destrua o apoio do outro gorila para derruba-lo!", _RGB32(255, 213, 109)
    TextWorld 70, 570, "Pressione qualquer tecla para voltar", _RGB32(190, 210, 238)
END SUB

' Editor nao bloqueante de nomes: somente caracteres seguros para JSON.
SUB DrawNameEditor
    CLS , _RGB32(20, 32, 55)
    TextWorld 80, 100, "CADASTRO DE JOGADOR " + LTRIM$(STR$(EditingPlayer)), _RGB32(255, 218, 86)
    TextWorld 80, 195, "Nome: " + NameBuffer + "_", _RGB32(235, 240, 255)
    TextWorld 80, 290, "A-Z 0-9 espaco, hifen e underline; ate 24 caracteres", _RGB32(185, 207, 230)
    TextWorld 80, 350, "ENTER: gravar | ESC: cancelar", _RGB32(185, 207, 230)
END SUB
