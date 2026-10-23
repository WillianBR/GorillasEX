' Regras da partida: dois humanos, ou um humano contra modo demonstracao.
SUB InitPlayers
    DIM lv_LoginName AS STRING
    ' Obtém o login do sistema operacional sem chamadas dependentes de Windows.
    lv_LoginName = SystemLoginName
    IF LEN(lv_LoginName) > 0 THEN
        Gorillas(1).Name = lv_LoginName
    ELSE
        Gorillas(1).Name = "PLAYER 1"
    END IF
    Gorillas(2).Name = "PLAYER 2"
    InitRound
END SUB

SUB InitRound
    DIM Index AS LONG
    IF SceneImage = 0 THEN CreateCity
    FOR Index = 1 TO 2
        Gorillas(Index).Alive = -1
        Gorillas(Index).Falling = 0
        Gorillas(Index).VelocityY = 0
        IF Index = 1 THEN Gorillas(Index).X = WorldWidth * .18
        IF Index = 2 THEN Gorillas(Index).X = WorldWidth * .82
        Gorillas(Index).Y = RoofAt(Gorillas(Index).X) - 37
    NEXT Index
    Projectile.Active = 0
    RoundFinished = 0
    VictoryStartedAt = -100
    RoundWinner = 0
    CurrentPlayer = 1
    ' Inicializa a mira individual apenas no inicio de cada rodada.
    PlayerAimAngle(1) = 45
    PlayerAimAngle(2) = 45
    PlayerAimPower(1) = 65
    PlayerAimPower(2) = 65
    AimAngle = PlayerAimAngle(CurrentPlayer)
    AimPower = PlayerAimPower(CurrentPlayer)
    Wind = (RND - .5) * 130
    StatusText = "Use setas para angulo/forca; ESPACO dispara"
    StatusUntil = GameTime + 4
END SUB

SUB BeginMatch
    DIM Index AS LONG
    RoundNumber = 1
    MatchFinished = 0
    CurrentPage = 1
    Gorillas(1).Wins = 0
    Gorillas(2).Wins = 0
    IF DemoMode <> 0 THEN Gorillas(2).Name = "COMPUTADOR"
    IF DemoMode = 0 AND Gorillas(2).Name = "COMPUTADOR" THEN Gorillas(2).Name = "PLAYER 2"
    CitySeed = CLNG(RND * 2000000000)
    CreateCity
    InitRound
END SUB

SUB NextRound
    IF MatchFinished <> 0 THEN
        BeginMatch
        EXIT SUB
    END IF
    RoundNumber = RoundNumber + 1
    CitySeed = CLNG(RND * 2000000000)
    CreateCity
    InitRound
END SUB

SUB RegisterRoundWinner (Winner AS LONG)
    IF RoundFinished <> 0 THEN EXIT SUB
    RoundWinner = Winner
    RoundFinished = -1
    VictoryStartedAt = GameTime
    Projectile.Active = 0
    IF Winner >= 1 AND Winner <= 2 THEN
        Gorillas(Winner).Wins = Gorillas(Winner).Wins + 1
        StatusText = Gorillas(Winner).Name + " venceu! ENTER para continuar."
        StartSound 4
    ELSE
        StatusText = "Empate! ENTER para continuar."
        StartSound 3
    END IF
    IF RoundNumber >= RoundLimit THEN
        MatchFinished = -1
        UpdateRanking
        SaveRanking
        StatusText = "Partida encerrada. ENTER reinicia ou ESC abre o menu."
    END IF
END SUB

' Troca o jogador mantendo os ajustes exclusivos de cada um.
SUB SetCurrentPlayer (p_PlayerNumber AS LONG)
    IF p_PlayerNumber < 1 OR p_PlayerNumber > 2 THEN EXIT SUB
    CurrentPlayer = p_PlayerNumber
    AimAngle = PlayerAimAngle(CurrentPlayer)
    AimPower = PlayerAimPower(CurrentPlayer)
END SUB

SUB FireBanana
    DIM AngleRadians AS DOUBLE, Direction AS DOUBLE
    IF Projectile.Active <> 0 OR RoundFinished <> 0 THEN EXIT SUB
    IF Gorillas(CurrentPlayer).Falling <> 0 THEN EXIT SUB
    Direction = 1
    IF CurrentPlayer = 2 THEN Direction = -1
    ' O disparo pertence ao jogador ativo, sem sobrescrever o outro.
    PlayerAimAngle(CurrentPlayer) = AimAngle
    PlayerAimPower(CurrentPlayer) = AimPower
    AngleRadians = AimAngle * Pi / 180
    Projectile.X = Gorillas(CurrentPlayer).X + Direction * 20
    Projectile.Y = Gorillas(CurrentPlayer).Y + 8
    Projectile.PreviousX = Projectile.X
    Projectile.PreviousY = Projectile.Y
    Projectile.VelocityX = Direction * COS(AngleRadians) * AimPower * 7
    Projectile.VelocityY = -SIN(AngleRadians) * AimPower * 7
    Projectile.Owner = CurrentPlayer
    Projectile.Active = -1
    CountThrow CurrentPlayer
    StartSound 1
END SUB

SUB CountThrow (Index AS LONG)
    DIM Rec AS LONG
    Rec = FindRecord(Gorillas(Index).Name)
    IF Rec > 0 THEN Records(Rec).Throws = Records(Rec).Throws + 1
END SUB

SUB CountHit (Index AS LONG)
    DIM Rec AS LONG
    Rec = FindRecord(Gorillas(Index).Name)
    IF Rec > 0 THEN Records(Rec).Hits = Records(Rec).Hits + 1
END SUB

' Obtém o nome de login do usuario atual usando variaveis do ambiente.
' Nao representa autenticacao nem identidade verificada: pode ser editada pelo processo.
' DEFSTR S no programa principal define o retorno STRING sem sufixos antigos.
FUNCTION SystemLoginName
    DIM lv_LoginName AS STRING
    DIM lv_Result AS STRING
    DIM lv_Index AS LONG
    DIM lv_Character AS STRING

    ' Windows: USERNAME. Linux/macOS: USER e LOGNAME.
    lv_LoginName = _TRIM$(ENVIRON$("USERNAME"))
    IF LEN(lv_LoginName) = 0 THEN lv_LoginName = _TRIM$(ENVIRON$("USER"))
    IF LEN(lv_LoginName) = 0 THEN lv_LoginName = _TRIM$(ENVIRON$("LOGNAME"))

    ' Evita que caracteres de controle prejudiquem o desenho do HUD.
    lv_Result = ""
    FOR lv_Index = 1 TO LEN(lv_LoginName)
        lv_Character = MID$(lv_LoginName, lv_Index, 1)
        IF ASC(lv_Character) >= 32 AND ASC(lv_Character) <> 127 THEN
            lv_Result = lv_Result + lv_Character
        END IF
        IF LEN(lv_Result) >= 24 THEN EXIT FOR
    NEXT lv_Index
    SystemLoginName = lv_Result
END FUNCTION
