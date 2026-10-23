' Gerador de cidade: alterna predios de alturas variadas e pequenos vazios.
' O espaco vazio e solido apenas quando existe terreno; nao se inventa apoio.
SUB CreateCity
    DIM lv_GX AS LONG, lv_GY AS LONG, lv_BuildingLeft AS LONG
    DIM lv_BuildingWidth AS LONG, lv_RoofY AS LONG, lv_Number AS LONG
    DIM lv_SavedSeed AS LONG, lv_GapWidth AS LONG, lv_LastRoofY AS LONG
    DIM lv_Change AS LONG, lv_Center AS LONG, lv_SpawnOne AS LONG, lv_SpawnTwo AS LONG
    lv_SavedSeed = CitySeed
    RANDOMIZE lv_SavedSeed
    FOR lv_GX = 0 TO MaxGridX
        FOR lv_GY = 0 TO MaxGridY
            Terrain(lv_GX, lv_GY) = 0
        NEXT lv_GY
    NEXT lv_GX
    lv_BuildingLeft = 0
    lv_Number = 1
    lv_LastRoofY = 310
    lv_SpawnOne = INT(WorldWidth * .18)
    lv_SpawnTwo = INT(WorldWidth * .82)
    DO WHILE lv_BuildingLeft < WorldWidth
        lv_BuildingWidth = 58 + INT(RND * 100)
        ' Em media uma lacuna a cada oito predios; nunca sob os jogadores.
        lv_GapWidth = 0
        IF RND < .12 THEN lv_GapWidth = 20 + INT(RND * 43)
        IF lv_BuildingLeft < lv_SpawnOne + 55 AND lv_BuildingLeft + lv_GapWidth + lv_BuildingWidth > lv_SpawnOne - 55 THEN lv_GapWidth = 0
        IF lv_BuildingLeft < lv_SpawnTwo + 55 AND lv_BuildingLeft + lv_GapWidth + lv_BuildingWidth > lv_SpawnTwo - 55 THEN lv_GapWidth = 0
        lv_BuildingLeft = lv_BuildingLeft + lv_GapWidth
        ' Mistura saltos grandes com alteracoes suaves para evitar perfil uniforme.
        lv_Change = INT(RND * 251) - 125
        IF RND < .35 THEN lv_Change = INT(RND * 351) - 175
        lv_RoofY = lv_LastRoofY + lv_Change
        IF lv_RoofY < 265 THEN lv_RoofY = 265 + INT(RND * 48)
        IF lv_RoofY > 520 THEN lv_RoofY = 480 + INT(RND * 41)
        lv_LastRoofY = lv_RoofY
        FOR lv_GX = lv_BuildingLeft \ GridSize TO (lv_BuildingLeft + lv_BuildingWidth) \ GridSize
            IF lv_GX >= 0 AND lv_GX <= MaxGridX THEN
                FOR lv_GY = lv_RoofY \ GridSize TO MaxGridY
                    Terrain(lv_GX, lv_GY) = lv_Number
                NEXT lv_GY
            END IF
        NEXT lv_GX
        lv_BuildingLeft = lv_BuildingLeft + lv_BuildingWidth
        lv_Number = lv_Number + 1
        IF lv_Number > 99 THEN lv_Number = 1
    LOOP
    BuildingCount = lv_Number - 1
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
