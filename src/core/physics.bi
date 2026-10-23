' Simulacao deterministica com integracao de passo fixo.
SUB UpdatePhysics (TimeStep AS DOUBLE)
    DIM I AS LONG, Segment AS LONG, Steps AS LONG, Hit AS INTEGER
    DIM T AS DOUBLE, X AS DOUBLE, Y AS DOUBLE, PrevX AS DOUBLE, PrevY AS DOUBLE
    IF RoundFinished <> 0 THEN EXIT SUB
    IF Projectile.Active <> 0 THEN
        PrevX = Projectile.X
        PrevY = Projectile.Y
        Projectile.VelocityX = Projectile.VelocityX + Wind * TimeStep
        Projectile.VelocityY = Projectile.VelocityY + Gravity * TimeStep
        Projectile.X = Projectile.X + Projectile.VelocityX * TimeStep
        Projectile.Y = Projectile.Y + Projectile.VelocityY * TimeStep
        ' Colisao ao longo do segmento; impede atravessar paredes finas.
        Steps = INT(SQR((Projectile.X - PrevX) ^ 2 + (Projectile.Y - PrevY) ^ 2) / 2) + 1
        Hit = 0
        FOR Segment = 1 TO Steps
            T = Segment / Steps
            X = PrevX + (Projectile.X - PrevX) * T
            Y = PrevY + (Projectile.Y - PrevY) * T
            IF X < 0 OR X >= WorldWidth OR Y >= WorldHeight THEN
                Projectile.Active = 0
                EXIT FOR
            END IF
            IF Y > 0 THEN
                FOR I = 1 TO 2
                    IF Gorillas(I).Alive <> 0 AND I <> Projectile.Owner THEN
                        IF ABS(X - Gorillas(I).X) < 16 AND Y >= Gorillas(I).Y AND Y <= Gorillas(I).Y + 37 THEN
                            Hit = I
                            EXIT FOR
                        END IF
                    END IF
                NEXT I
                IF Hit = 0 AND IsSolid(X, Y) THEN Hit = 3
                IF Hit <> 0 THEN
                    Projectile.Active = 0
                    CarveExplosion X, Y, 33
                    StartSound 3
                    IF Hit < 3 THEN
                        CountHit Projectile.Owner
                        Gorillas(Hit).Alive = 0
                    END IF
                    EXIT FOR
                END IF
            END IF
        NEXT Segment
        IF Projectile.Y < -WorldHeight THEN Projectile.Active = 0
        IF Projectile.Active = 0 AND Hit = 0 THEN
            SetCurrentPlayer 3 - CurrentPlayer
        END IF
        IF Projectile.Active = 0 AND Hit <> 0 THEN
            SetCurrentPlayer 3 - CurrentPlayer
        END IF
    END IF
    ' O gorila cai se a explosao destruir a base sob seus pes.
    FOR I = 1 TO 2
        IF Gorillas(I).Alive <> 0 THEN
            IF IsSolid(Gorillas(I).X, Gorillas(I).Y + 39) = 0 THEN
                IF Gorillas(I).Falling = 0 THEN
                    Gorillas(I).Falling = -1
                    Gorillas(I).FallStart = Gorillas(I).Y
                    Gorillas(I).VelocityY = 0
                END IF
            END IF
            IF Gorillas(I).Falling <> 0 THEN
                Gorillas(I).VelocityY = Gorillas(I).VelocityY + Gravity * TimeStep
                Gorillas(I).Y = Gorillas(I).Y + Gorillas(I).VelocityY * TimeStep
                IF IsSolid(Gorillas(I).X, Gorillas(I).Y + 39) THEN
                    Gorillas(I).Y = RoofAt(Gorillas(I).X) - 38
                    Gorillas(I).Falling = 0
                    IF Gorillas(I).Y - Gorillas(I).FallStart > 85 THEN
                        Gorillas(I).Alive = 0
                        StartSound 3
                    ELSE
                        StartSound 2
                    END IF
                END IF
                IF Gorillas(I).Y > WorldHeight THEN Gorillas(I).Alive = 0
            END IF
        END IF
    NEXT I
    IF Gorillas(1).Alive = 0 AND Gorillas(2).Alive = 0 THEN RegisterRoundWinner 0
    IF Gorillas(1).Alive = 0 AND Gorillas(2).Alive <> 0 THEN RegisterRoundWinner 2
    IF Gorillas(2).Alive = 0 AND Gorillas(1).Alive <> 0 THEN RegisterRoundWinner 1
    IF DemoMode <> 0 AND CurrentPlayer = 2 AND Projectile.Active = 0 AND RoundFinished = 0 THEN
        ' IA simples v1; os disparos usam a mesma rotina dos humanos.
        AimAngle = 30 + INT(RND * 47)
        AimPower = 42 + INT(RND * 49)
        PlayerAimAngle(2) = AimAngle
        PlayerAimPower(2) = AimPower
        FireBanana
    END IF
END SUB
