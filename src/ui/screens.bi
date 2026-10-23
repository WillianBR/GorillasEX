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

' Painel de ajuda F1, desenhado em coordenadas do mundo.
' A arte PNG e opcional: ausencia do arquivo nao impede o jogo.
SUB LoadHelpArtwork
    HelpImage = 0
    IF _FILEEXISTS("assets/icons/GorillasEX.png") THEN
        HelpImage = _LOADIMAGE("assets/icons/GorillasEX.png", 32)
    ELSEIF _FILEEXISTS("src/assets/icons/GorillasEX.png") THEN
        HelpImage = _LOADIMAGE("src/assets/icons/GorillasEX.png", 32)
    END IF
END SUB

SUB DrawHelp
    DIM lv_PanelRight AS DOUBLE, lv_ArtworkLeft AS DOUBLE
    DIM lv_RightEdge AS DOUBLE
    lv_RightEdge = WorldWidth - 28
    lv_PanelRight = WorldWidth - 54
    lv_ArtworkLeft = WorldWidth - 280
    CLS , _RGB32(17, 26, 48)
    BoxWorld 30, 26, lv_PanelRight, 620, _RGB32(29, 44, 72)
    TextWorld 58, 48, "GORILLASEX  |  AJUDA (F1)", _RGB32(255, 217, 85)
    TextWorld 58, 102, "SETA CIMA / BAIXO    Angulo", _RGB32(220, 236, 246)
    TextWorld 58, 141, "SETA ESQ. / DIREITA  Potencia", _RGB32(220, 236, 246)
    TextWorld 58, 180, "ESPACO / CLIQUE       Lancar banana", _RGB32(220, 236, 246)
    TextWorld 58, 219, "ENTER                 Proxima rodada", _RGB32(220, 236, 246)
    TextWorld 58, 258, "ESC                   Voltar ao menu", _RGB32(220, 236, 246)
    TextWorld 58, 297, "M                     Som ligado/desligado", _RGB32(220, 236, 246)
    TextWorld 58, 336, "F11                   Tela cheia", _RGB32(220, 236, 246)
    TextWorld 58, 375, "F3                    Diagnosticos", _RGB32(220, 236, 246)
    TextWorld 58, 420, "DICA: destrua o teto sob o rival!", _RGB32(255, 213, 109)
    TextWorld 58, 466, "F1 / ENTER / clique: retornar", _RGB32(183, 210, 242)
    IF HelpImage < -1 THEN
        _PUTIMAGE (Px(lv_ArtworkLeft), Py(120))-(Px(WorldWidth - 76), Py(352)), HelpImage
    END IF
    TextWorld 58, 582, "GorillasEX - feito com assistencia de IA", _RGB32(160, 183, 208)
    TextWorld WorldWidth - 320, 603, "Copyright (c) 2026 WillianBR", _RGB32(192, 199, 216)
END SUB

' Editor nao bloqueante de nomes: somente caracteres seguros para JSON.
SUB DrawNameEditor
    CLS , _RGB32(20, 32, 55)
    TextWorld 80, 100, "CADASTRO DE JOGADOR " + LTRIM$(STR$(EditingPlayer)), _RGB32(255, 218, 86)
    TextWorld 80, 195, "Nome: " + NameBuffer + "_", _RGB32(235, 240, 255)
    TextWorld 80, 290, "A-Z 0-9 espaco, hifen e underline; ate 24 caracteres", _RGB32(185, 207, 230)
    TextWorld 80, 350, "ENTER: gravar | ESC: cancelar", _RGB32(185, 207, 230)
END SUB

' Painel modal multiplataforma com confirmacao explicita de encerramento.
SUB DrawExitDialog
    DIM lv_Left AS DOUBLE, lv_Right AS DOUBLE
    DIM lv_ButtonY AS DOUBLE, lv_YesColor AS _UNSIGNED LONG
    DIM lv_NoColor AS _UNSIGNED LONG
    lv_Left = WorldWidth / 2 - 245
    lv_Right = WorldWidth / 2 + 245
    lv_ButtonY = 360
    ' Uma borda destacada evidencia que a tela de fundo esta temporariamente bloqueada.
    BoxWorld lv_Left - 4, 235, lv_Right + 4, 434, _RGB32(235, 183, 65)
    BoxWorld lv_Left, 239, lv_Right, 430, _RGB32(23, 37, 62)
    TextWorld lv_Left + 34, 260, "GORILLASEX - SAIR DO JOGO?", _RGB32(255, 218, 95)
    TextWorld lv_Left + 34, 302, "Deseja realmente encerrar a partida?", _RGB32(226, 235, 247)
    lv_YesColor = _RGB32(67, 85, 109)
    lv_NoColor = _RGB32(67, 85, 109)
    IF ExitDialogSelection = 1 THEN lv_YesColor = _RGB32(137, 85, 49)
    IF ExitDialogSelection = 2 THEN lv_NoColor = _RGB32(50, 123, 96)
    BoxWorld WorldWidth / 2 - 154, lv_ButtonY, WorldWidth / 2 - 14, lv_ButtonY + 45, lv_YesColor
    BoxWorld WorldWidth / 2 + 14, lv_ButtonY, WorldWidth / 2 + 154, lv_ButtonY + 45, lv_NoColor
    TextWorld WorldWidth / 2 - 106, lv_ButtonY + 12, "SIM", _RGB32(255, 255, 255)
    TextWorld WorldWidth / 2 + 72, lv_ButtonY + 12, "NAO", _RGB32(255, 255, 255)
    TextWorld lv_Left + 35, 413, "Setas/TAB: escolher | ENTER: confirmar | ESC: cancelar", _RGB32(192, 207, 225)
END SUB
