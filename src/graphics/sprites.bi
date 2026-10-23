' Desenhos procedurais RGBA: nenhum PNG ou sprite externo e exigido.
SUB DrawGorilla (Index AS LONG)
    DIM X AS DOUBLE, Y AS DOUBLE, Fur AS _UNSIGNED LONG
    DIM lv_VictoryElapsed AS DOUBLE, lv_DanceFrame AS LONG
    DIM lv_ArmLeftTop AS DOUBLE, lv_ArmRightTop AS DOUBLE
    lv_VictoryElapsed = GameTime - VictoryStartedAt
    lv_DanceFrame = 0
    IF RoundFinished <> 0 AND RoundWinner = Index AND lv_VictoryElapsed >= 0 AND lv_VictoryElapsed < 5 THEN
        lv_DanceFrame = INT(lv_VictoryElapsed * 5) MOD 4
    END IF
    X = Gorillas(Index).X
    Y = Gorillas(Index).Y
    IF Gorillas(Index).Alive = 0 THEN EXIT SUB
    Fur = _RGB32(118, 79, 58)
    IF lv_DanceFrame = 1 OR lv_DanceFrame = 3 THEN X = X + 3 - 2 * lv_DanceFrame
    IF lv_DanceFrame = 1 OR lv_DanceFrame = 2 THEN Y = Y - 7
    ' Bracos maiores e postura distinta ao vencer a rodada.
    IF RoundFinished <> 0 AND RoundWinner = Index THEN
        lv_ArmLeftTop = Y - 9
        lv_ArmRightTop = Y - 9
        IF lv_DanceFrame = 1 THEN lv_ArmLeftTop = Y + 4
        IF lv_DanceFrame = 3 THEN lv_ArmRightTop = Y + 4
        BoxWorld X - 19, lv_ArmLeftTop, X - 11, Y + 14, Fur
        BoxWorld X + 11, lv_ArmRightTop, X + 19, Y + 14, Fur
    ELSE
        BoxWorld X - 17, Y + 12, X - 10, Y + 29, Fur
        BoxWorld X + 10, Y + 12, X + 17, Y + 29, Fur
    END IF
    BoxWorld X - 12, Y + 13, X + 12, Y + 30, Fur
    BoxWorld X - 11, Y + 28, X - 3, Y + 37, Fur
    BoxWorld X + 3, Y + 28, X + 11, Y + 37, Fur
    CircleWorld X, Y + 8, 12, Fur
    PAINT (Px(X), Py(Y + 8)), Fur
    BoxWorld X - 8, Y + 7, X + 8, Y + 14, _RGB32(182, 139, 111)
    CircleWorld X - 4, Y + 7, 1.5, _RGB32(255, 255, 255)
    CircleWorld X + 4, Y + 7, 1.5, _RGB32(255, 255, 255)
    BoxWorld X - 3, Y + 11, X + 3, Y + 12, _RGB32(45, 34, 39)
END SUB

SUB DrawBanana
    DIM lv_CenterX AS DOUBLE, lv_CenterY AS DOUBLE
    DIM lv_Spin AS DOUBLE, lv_CosAngle AS DOUBLE, lv_SinAngle AS DOUBLE
    DIM lv_Progress AS DOUBLE, lv_LocalX AS DOUBLE, lv_LocalY AS DOUBLE
    DIM lv_WorldX AS DOUBLE, lv_WorldY AS DOUBLE, lv_Radius AS DOUBLE
    DIM lv_OuterColor AS _UNSIGNED LONG, lv_InnerColor AS _UNSIGNED LONG
    DIM lv_Index AS LONG, lv_Pass AS LONG
    IF Projectile.Active = 0 THEN EXIT SUB
    lv_CenterX = Projectile.X
    lv_CenterY = Projectile.Y
    ' Rotacao continua: a banana permanece distinguivel em qualquer orientacao.
    lv_Spin = GameTime * 9
    lv_CosAngle = COS(lv_Spin)
    lv_SinAngle = SIN(lv_Spin)
    ' Construcao de uma meia-lua, nao um circulo com uma faixa diagonal.
    ' Primeiro desenha um contorno escuro; depois uma casca amarela mais fina.
    FOR lv_Pass = 1 TO 2
        FOR lv_Index = 0 TO 28
            lv_Progress = lv_Index / 28
            lv_LocalX = (lv_Progress - .5) * 25
            lv_LocalY = 5 - SIN(lv_Progress * Pi) * 11
            lv_WorldX = lv_CenterX + lv_LocalX * lv_CosAngle - lv_LocalY * lv_SinAngle
            lv_WorldY = lv_CenterY + lv_LocalX * lv_SinAngle + lv_LocalY * lv_CosAngle
            lv_Radius = 1.1 + SIN(lv_Progress * Pi) * 2.9
            IF lv_Pass = 1 THEN
                lv_Radius = lv_Radius + .8
                lv_OuterColor = _RGB32(99, 61, 23)
            ELSE
                lv_OuterColor = _RGB32(250, 205, 42)
                IF lv_Progress > .18 AND lv_Progress < .78 THEN lv_OuterColor = _RGB32(255, 224, 64)
            END IF
            ' Circulo preenchido por PAINT sobre o contorno recem desenhado.
            CircleWorld lv_WorldX, lv_WorldY, lv_Radius, lv_OuterColor
            PAINT (Px(lv_WorldX), Py(lv_WorldY)), lv_OuterColor, lv_OuterColor
        NEXT lv_Index
    NEXT lv_Pass
    ' Extremidades castanhas tornam o desenho reconhecivel em HD e QHD.
    FOR lv_Index = 0 TO 1
        lv_Progress = lv_Index
        lv_LocalX = (lv_Progress - .5) * 25
        lv_LocalY = 5
        lv_WorldX = lv_CenterX + lv_LocalX * lv_CosAngle - lv_LocalY * lv_SinAngle
        lv_WorldY = lv_CenterY + lv_LocalX * lv_SinAngle + lv_LocalY * lv_CosAngle
        CircleWorld lv_WorldX, lv_WorldY, 1.8, _RGB32(77, 47, 24)
        PAINT (Px(lv_WorldX), Py(lv_WorldY)), _RGB32(77, 47, 24), _RGB32(77, 47, 24)
    NEXT lv_Index
END SUB
