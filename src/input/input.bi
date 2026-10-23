' Eventos de teclado e mouse. Navegacao sem leitura bloqueante.
SUB PollMouse
    DIM DownNow AS INTEGER
    DO WHILE _MOUSEINPUT
    LOOP
    MouseX = _MOUSEX * WorldWidth / ScreenWidth
    MouseY = _MOUSEY * WorldHeight / ScreenHeight
    DownNow = _MOUSEBUTTON(1)
    MouseClicked = 0
    IF DownNow <> 0 AND PrevMouseDown = 0 THEN MouseClicked = -1
    PrevMouseDown = DownNow
END SUB

SUB HandleInput (KeyText AS STRING)
    DIM Code AS LONG
    DIM ValidChars AS STRING
    IF CurrentPage = 4 THEN
        IF KeyText = CHR$(13) THEN
            IF LEN(NameBuffer) > 0 THEN Gorillas(EditingPlayer).Name = NameBuffer
            CurrentPage = 0
        ELSEIF KeyText = CHR$(8) THEN
            IF LEN(NameBuffer) > 0 THEN NameBuffer = LEFT$(NameBuffer, LEN(NameBuffer) - 1)
        ELSEIF LEN(KeyText) = 1 THEN
            ValidChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 -_"
            IF INSTR(ValidChars, KeyText) > 0 AND LEN(NameBuffer) < 24 THEN NameBuffer = NameBuffer + KeyText
        END IF
        IF KeyText = CHR$(27) THEN CurrentPage = 0
        EXIT SUB
    END IF
    IF KeyText = CHR$(27) THEN
        CurrentPage = 0
        SelectedMenu = 1
        EXIT SUB
    END IF
    IF KeyText = CHR$(0) + CHR$(63) THEN ShowDebug = NOT ShowDebug
    IF KeyText = "m" OR KeyText = "M" THEN SoundEnabled = NOT SoundEnabled
    IF KeyText = CHR$(0) + CHR$(133) THEN ToggleFullscreen
    IF CurrentPage = 0 THEN
        IF KeyText = CHR$(0) + CHR$(72) THEN SelectedMenu = SelectedMenu - 1
        IF KeyText = CHR$(0) + CHR$(80) THEN SelectedMenu = SelectedMenu + 1
        IF SelectedMenu < 1 THEN SelectedMenu = 8
        IF SelectedMenu > 8 THEN SelectedMenu = 1
        IF MouseClicked <> 0 THEN
            IF MouseY >= 210 AND MouseY < 210 + 8 * 43 THEN
                SelectedMenu = INT((MouseY - 210) / 43) + 1
                ExecuteMenu
            END IF
        END IF
        IF KeyText = CHR$(13) THEN ExecuteMenu
        EXIT SUB
    END IF
    IF CurrentPage = 2 THEN
        IF KeyText = CHR$(0) + CHR$(77) OR KeyText = CHR$(0) + CHR$(81) THEN RankingPage = RankingPage + 1
        IF KeyText = CHR$(0) + CHR$(75) OR KeyText = CHR$(0) + CHR$(73) THEN RankingPage = RankingPage - 1
        IF RankingPage < 0 THEN RankingPage = 0
        IF RankingPage * 20 >= RecordCount AND RecordCount > 0 THEN RankingPage = (RecordCount - 1) \ 20
        IF KeyText = CHR$(13) OR MouseClicked <> 0 THEN CurrentPage = 0
        EXIT SUB
    END IF
    IF CurrentPage = 3 THEN
        IF KeyText <> "" OR MouseClicked <> 0 THEN CurrentPage = 0
        EXIT SUB
    END IF
    IF CurrentPage <> 1 THEN EXIT SUB
    IF RoundFinished <> 0 THEN
        IF KeyText = CHR$(13) OR MouseClicked <> 0 THEN NextRound
        EXIT SUB
    END IF
    IF Projectile.Active <> 0 THEN EXIT SUB
    IF DemoMode <> 0 AND CurrentPlayer = 2 THEN EXIT SUB
    IF KeyText = CHR$(0) + CHR$(72) THEN AimAngle = AimAngle + 1
    IF KeyText = CHR$(0) + CHR$(80) THEN AimAngle = AimAngle - 1
    IF KeyText = CHR$(0) + CHR$(77) THEN AimPower = AimPower + 1
    IF KeyText = CHR$(0) + CHR$(75) THEN AimPower = AimPower - 1
    IF AimAngle < 5 THEN AimAngle = 5
    IF AimAngle > 85 THEN AimAngle = 85
    IF AimPower < 10 THEN AimPower = 10
    IF AimPower > 100 THEN AimPower = 100
    ' Atualiza apenas a mira do jogador humano ativo.
    PlayerAimAngle(CurrentPlayer) = AimAngle
    PlayerAimPower(CurrentPlayer) = AimPower
    IF KeyText = " " OR MouseClicked <> 0 THEN FireBanana
END SUB

SUB ExecuteMenu
    SELECT CASE SelectedMenu
        CASE 1
            DemoMode = 0
            BeginMatch
        CASE 2
            DemoMode = -1
            BeginMatch
        CASE 3
            EditingPlayer = 1
            NameBuffer = Gorillas(1).Name
            CurrentPage = 4
        CASE 4
            EditingPlayer = 2
            NameBuffer = Gorillas(2).Name
            CurrentPage = 4
        CASE 5
            SortRanking
            RankingPage = 0
            CurrentPage = 2
        CASE 6
            CurrentPage = 3
        CASE 7
            IF ScreenWidth = 1280 THEN
                ResizeDisplay 1600, 900
            ELSEIF ScreenWidth = 1600 THEN
                ResizeDisplay 1920, 1080
            ELSEIF ScreenWidth = 1920 THEN
                ResizeDisplay 2560, 1440
            ELSE
                ResizeDisplay 1280, 720
            END IF
        CASE 8
            QuitRequested = -1
    END SELECT
END SUB

SUB ToggleFullscreen
    IF _FULLSCREEN = 0 THEN
        _FULLSCREEN _SQUAREPIXELS
    ELSE
        _FULLSCREEN _OFF
    END IF
END SUB
