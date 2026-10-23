' Transformacoes mundo -> pixels; toda a geometria e rasterizada em 32 bits.
FUNCTION Px (Position AS DOUBLE)
    Px = CLNG(Position * ScreenWidth / WorldWidth)
END FUNCTION
FUNCTION Py (Position AS DOUBLE)
    Py = CLNG(Position * ScreenHeight / WorldHeight)
END FUNCTION
SUB BoxWorld (LeftX AS DOUBLE, TopY AS DOUBLE, RightX AS DOUBLE, BottomY AS DOUBLE, ColorValue AS _UNSIGNED LONG)
    LINE (Px(LeftX), Py(TopY))-(Px(RightX), Py(BottomY)), ColorValue, BF
END SUB
SUB CircleWorld (CenterX AS DOUBLE, CenterY AS DOUBLE, Radius AS DOUBLE, ColorValue AS _UNSIGNED LONG)
    DIM ScaledRadius AS DOUBLE
    ScaledRadius = Radius * ScreenHeight / WorldHeight
    IF ScaledRadius < 1 THEN ScaledRadius = 1
    CIRCLE (Px(CenterX), Py(CenterY)), ScaledRadius, ColorValue
END SUB
SUB TextWorld (X AS DOUBLE, Y AS DOUBLE, Caption AS STRING, ColorValue AS _UNSIGNED LONG)
    COLOR ColorValue
    _PRINTMODE _KEEPBACKGROUND
    _PRINTSTRING (Px(X), Py(Y)), Caption
END SUB
SUB InitScene
    IF SceneImage < -1 THEN _FREEIMAGE SceneImage
    SceneImage = _NEWIMAGE(ScreenWidth, ScreenHeight, 32)
END SUB

SUB RenderCity
    ' Cache grafico: a cena so e reconstruida apos explosao ou novo mapa.
    DIM OldDest AS LONG, RowNumber AS LONG, GX AS LONG, RunStart AS LONG
    DIM Y AS LONG, X AS LONG, Brightness AS LONG, Fill AS _UNSIGNED LONG
    OldDest = _DEST
    _DEST SceneImage
    FOR Y = 0 TO ScreenHeight - 1 STEP 3
        Brightness = 17 + (Y * 52 \ ScreenHeight)
        LINE (0, Y)-(ScreenWidth, Y + 3), _RGB32(12, Brightness, Brightness + 44), BF
    NEXT Y
    ' A lua/sol e um detalhe de fundo, sem participar das colisoes.
    CIRCLE (Px(WorldWidth / 2), Py(90)), 38 * ScreenHeight / WorldHeight, _RGB32(253, 210, 95)
    PAINT (Px(WorldWidth / 2), Py(90)), _RGB32(253, 210, 95)
    ' Cada sequencia de celulas solidas vira um retangulo; sem POINT no motor.
    FOR RowNumber = 0 TO MaxGridY
        RunStart = -1
        FOR GX = 0 TO (WorldWidth \ GridSize)
            IF GX <= MaxGridX THEN
                IF Terrain(GX, RowNumber) <> 0 THEN
                    IF RunStart = -1 THEN RunStart = GX
                ELSE
                    IF RunStart >= 0 THEN
                        Fill = BuildingColor(Terrain(RunStart, RowNumber))
                        BoxWorld RunStart * GridSize, RowNumber * GridSize, GX * GridSize, (RowNumber + 1) * GridSize, Fill
                        RunStart = -1
                    END IF
                END IF
            END IF
        NEXT GX
        IF RunStart >= 0 THEN
            Fill = BuildingColor(Terrain(RunStart, RowNumber))
            BoxWorld RunStart * GridSize, RowNumber * GridSize, WorldWidth, (RowNumber + 1) * GridSize, Fill
        END IF
    NEXT RowNumber
    ' As janelas sao decorativas e desenhadas sobre a mascara fisica.
    FOR X = 18 TO WorldWidth - 12 STEP 21
        FOR Y = 145 TO WorldHeight - 18 STEP 26
            GX = X \ GridSize
            RowNumber = Y \ GridSize
            IF GX <= MaxGridX AND RowNumber <= MaxGridY THEN
                IF Terrain(GX, RowNumber) <> 0 THEN
                    Brightness = (X * 17 + Y * 23 + CitySeed MOD 97) MOD 9
                    IF Brightness < 4 THEN
                        BoxWorld X, Y, X + 8, Y + 11, _RGB32(228, 202, 105)
                        IF Brightness = 0 AND (X + Y) MOD 13 = 0 THEN
                            ' Pequena silhueta: espectador gorila na janela.
                            CircleWorld X + 4, Y + 5, 2.8, _RGB32(61, 42, 42)
                            BoxWorld X + 2, Y + 7, X + 6, Y + 10, _RGB32(61, 42, 42)
                        END IF
                    ELSE
                        BoxWorld X, Y, X + 8, Y + 11, _RGB32(35, 44, 66)
                    END IF
                END IF
            END IF
        NEXT Y
    NEXT X
    _DEST OldDest
END SUB

FUNCTION BuildingColor (Number AS LONG)
    SELECT CASE Number MOD 5
        CASE 0: BuildingColor = _RGB32(89, 85, 115)
        CASE 1: BuildingColor = _RGB32(73, 100, 115)
        CASE 2: BuildingColor = _RGB32(114, 85, 103)
        CASE 3: BuildingColor = _RGB32(72, 85, 105)
        CASE ELSE: BuildingColor = _RGB32(90, 96, 112)
    END SELECT
END FUNCTION
