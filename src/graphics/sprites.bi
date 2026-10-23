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
    DIM X AS DOUBLE, Y AS DOUBLE
    IF Projectile.Active = 0 THEN EXIT SUB
    X = Projectile.X
    Y = Projectile.Y
    CircleWorld X, Y, 5, _RGB32(255, 217, 45)
    LINE (Px(X - 5), Py(Y - 3))-(Px(X + 4), Py(Y + 2)), _RGB32(255, 236, 108)
END SUB
