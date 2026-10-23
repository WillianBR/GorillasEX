' Desenhos procedurais RGBA: nenhum PNG ou sprite externo e exigido.
SUB DrawGorilla (Index AS LONG)
    DIM X AS DOUBLE, Y AS DOUBLE, Fur AS _UNSIGNED LONG
    X = Gorillas(Index).X
    Y = Gorillas(Index).Y
    IF Gorillas(Index).Alive = 0 THEN EXIT SUB
    Fur = _RGB32(118, 79, 58)
    ' Bracos maiores e postura distinta ao vencer a rodada.
    IF RoundFinished <> 0 AND RoundWinner = Index THEN
        BoxWorld X - 17, Y - 4, X - 10, Y + 13, Fur
        BoxWorld X + 10, Y - 4, X + 17, Y + 13, Fur
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
