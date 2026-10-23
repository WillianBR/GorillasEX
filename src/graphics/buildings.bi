' Gerador procedural e operacoes deterministicas sobre a mascara de solidez.
SUB CreateCity
    DIM GX AS LONG, GY AS LONG, BuildingLeft AS LONG
    DIM BuildingWidth AS LONG, RoofY AS LONG, Number AS LONG
    DIM SavedSeed AS LONG
    ' Restringimos o gerador ao limite disponivel na grade.
    SavedSeed = CitySeed
    RANDOMIZE SavedSeed
    FOR GX = 0 TO MaxGridX
        FOR GY = 0 TO MaxGridY
            Terrain(GX, GY) = 0
        NEXT GY
    NEXT GX
    BuildingLeft = 0
    Number = 1
    DO WHILE BuildingLeft < WorldWidth
        BuildingWidth = 80 + INT(RND * 90)
        RoofY = 205 + INT(RND * 240)
        FOR GX = BuildingLeft \ GridSize TO (BuildingLeft + BuildingWidth) \ GridSize
            IF GX >= 0 AND GX <= MaxGridX THEN
                FOR GY = RoofY \ GridSize TO MaxGridY
                    Terrain(GX, GY) = Number
                NEXT GY
            END IF
        NEXT GX
        BuildingLeft = BuildingLeft + BuildingWidth
        Number = Number + 1
        IF Number > 99 THEN Number = 1
    LOOP
    BuildingCount = Number - 1
    InitScene
    RenderCity
END SUB

FUNCTION IsSolid (X AS DOUBLE, Y AS DOUBLE)
    DIM GX AS LONG, GY AS LONG
    IF X < 0 OR X >= WorldWidth OR Y < 0 THEN EXIT FUNCTION
    IF Y >= WorldHeight THEN IsSolid = -1: EXIT FUNCTION
    GX = INT(X / GridSize)
    GY = INT(Y / GridSize)
    IF GX <= MaxGridX AND GY <= MaxGridY THEN
        IF Terrain(GX, GY) <> 0 THEN IsSolid = -1
    END IF
END FUNCTION

FUNCTION RoofAt (X AS DOUBLE)
    DIM Y AS LONG
    RoofAt = WorldHeight
    FOR Y = 0 TO WorldHeight - 1 STEP GridSize
        IF IsSolid(X, Y) THEN RoofAt = Y: EXIT FUNCTION
    NEXT Y
END FUNCTION

SUB CarveExplosion (X AS DOUBLE, Y AS DOUBLE, Radius AS DOUBLE)
    DIM GX AS LONG, GY AS LONG, LeftCell AS LONG, RightCell AS LONG
    DIM TopCell AS LONG, BottomCell AS LONG, DX AS DOUBLE, DY AS DOUBLE
    LeftCell = INT((X - Radius) / GridSize)
    RightCell = INT((X + Radius) / GridSize)
    TopCell = INT((Y - Radius) / GridSize)
    BottomCell = INT((Y + Radius) / GridSize)
    IF LeftCell < 0 THEN LeftCell = 0
    IF RightCell > MaxGridX THEN RightCell = MaxGridX
    IF TopCell < 0 THEN TopCell = 0
    IF BottomCell > MaxGridY THEN BottomCell = MaxGridY
    FOR GX = LeftCell TO RightCell
        FOR GY = TopCell TO BottomCell
            DX = (GX + .5) * GridSize - X
            DY = (GY + .5) * GridSize - Y
            IF DX * DX + DY * DY <= Radius * Radius THEN Terrain(GX, GY) = 0
        NEXT GY
    NEXT GX
    RenderCity
END SUB
