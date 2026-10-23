' Ranking JSON de esquema controlado. O leitor interpreta apenas nosso formato.
' Os nomes sao limitados a ASCII simples para impedir JSON invalido.
FUNCTION FindRecord (PlayerName AS STRING)
    DIM I AS LONG
    FOR I = 1 TO RecordCount
        IF UCASE$(Records(I).Name) = UCASE$(PlayerName) THEN
            FindRecord = I
            EXIT FUNCTION
        END IF
    NEXT I
END FUNCTION

FUNCTION EnsureRecord (PlayerName AS STRING)
    DIM Result AS LONG
    Result = FindRecord(PlayerName)
    IF Result > 0 THEN EnsureRecord = Result: EXIT FUNCTION
    IF RecordCount >= MaxPlayers THEN EXIT FUNCTION
    RecordCount = RecordCount + 1
    Records(RecordCount).Name = PlayerName
    EnsureRecord = RecordCount
END FUNCTION

SUB UpdateRanking
    DIM I AS LONG, Result AS LONG, WonMatch AS LONG
    IF Gorillas(1).Wins > Gorillas(2).Wins THEN WonMatch = 1
    IF Gorillas(2).Wins > Gorillas(1).Wins THEN WonMatch = 2
    FOR I = 1 TO 2
        IF DemoMode = 0 OR I = 1 THEN
            Result = EnsureRecord(Gorillas(I).Name)
            IF Result > 0 THEN
                Records(Result).Matches = Records(Result).Matches + 1
                Records(Result).Wins = Records(Result).Wins + Gorillas(I).Wins
                IF WonMatch = I THEN
                    ' Vitoria de partida: uma unidade adicional em W/L nao cabe no esquema.
                    ' Wins contabiliza rodadas vencidas; o README documenta esta regra.
                ELSE
                    Records(Result).Losses = Records(Result).Losses + 1
                END IF
            END IF
        END IF
    NEXT I
END SUB

FUNCTION JsonNumber (Source AS STRING, PropertyName AS STRING)
    DIM SearchKey AS STRING, Position AS LONG, First AS LONG, Last AS LONG
    SearchKey = CHR$(34) + PropertyName + CHR$(34) + ":"
    Position = INSTR(Source, SearchKey)
    IF Position = 0 THEN EXIT FUNCTION
    First = Position + LEN(SearchKey)
    Last = First
    DO WHILE Last <= LEN(Source)
        IF INSTR("0123456789", MID$(Source, Last, 1)) = 0 THEN EXIT DO
        Last = Last + 1
    LOOP
    JsonNumber = VAL(MID$(Source, First, Last - First))
END FUNCTION

' O prefixo S seleciona retorno STRING via DEFSTR S.
FUNCTION StringJsonName (Source AS STRING)
    DIM KeyPos AS LONG, StartAt AS LONG, EndAt AS LONG
    KeyPos = INSTR(Source, CHR$(34) + "name" + CHR$(34) + ":" + CHR$(34))
    IF KeyPos = 0 THEN EXIT FUNCTION
    StartAt = KeyPos + LEN(CHR$(34) + "name" + CHR$(34) + ":" + CHR$(34))
    EndAt = INSTR(StartAt, Source, CHR$(34))
    IF EndAt > StartAt THEN StringJsonName = MID$(Source, StartAt, EndAt - StartAt)
END FUNCTION

SUB LoadRanking
    DIM Filename AS STRING, RecordLine AS STRING, NewName AS STRING, Index AS LONG
    Filename = DataDirectory + "/ranking.json"
    IF _FILEEXISTS(Filename) = 0 THEN EXIT SUB
    OPEN Filename FOR INPUT AS #1
    DO WHILE NOT EOF(1)
        LINE INPUT #1, RecordLine
        NewName = StringJsonName(RecordLine)
        IF NewName <> "" AND LEN(NewName) <= 24 THEN
            Index = EnsureRecord(NewName)
            IF Index > 0 THEN
                Records(Index).Matches = JsonNumber(RecordLine, "matches")
                Records(Index).Wins = JsonNumber(RecordLine, "wins")
                Records(Index).Losses = JsonNumber(RecordLine, "losses")
                Records(Index).Throws = JsonNumber(RecordLine, "throws")
                Records(Index).Hits = JsonNumber(RecordLine, "hits")
            END IF
        END IF
    LOOP
    CLOSE #1
END SUB

SUB SaveRanking
    DIM Filename AS STRING, TempName AS STRING, BackupName AS STRING
    DIM I AS LONG, S AS STRING
    Filename = DataDirectory + "/ranking.json"
    TempName = DataDirectory + "/ranking.tmp"
    BackupName = DataDirectory + "/ranking.bak"
    OPEN TempName FOR OUTPUT AS #1
    PRINT #1, "{"
    PRINT #1, "  " + CHR$(34) + "schema" + CHR$(34) + ": 1,"
    PRINT #1, "  " + CHR$(34) + "players" + CHR$(34) + ": ["
    FOR I = 1 TO RecordCount
        S = "    {" + CHR$(34) + "name" + CHR$(34) + ":" + CHR$(34) + Records(I).Name + CHR$(34)
        S = S + "," + CHR$(34) + "matches" + CHR$(34) + ":" + LTRIM$(STR$(Records(I).Matches))
        S = S + "," + CHR$(34) + "wins" + CHR$(34) + ":" + LTRIM$(STR$(Records(I).Wins))
        S = S + "," + CHR$(34) + "losses" + CHR$(34) + ":" + LTRIM$(STR$(Records(I).Losses))
        S = S + "," + CHR$(34) + "throws" + CHR$(34) + ":" + LTRIM$(STR$(Records(I).Throws))
        S = S + "," + CHR$(34) + "hits" + CHR$(34) + ":" + LTRIM$(STR$(Records(I).Hits)) + "}"
        IF I < RecordCount THEN S = S + ","
        PRINT #1, S
    NEXT I
    PRINT #1, "  ]"
    PRINT #1, "}"
    CLOSE #1
    ' Preserva copia anterior; a substituicao pode falhar em caso de permissao.
    IF _FILEEXISTS(BackupName) THEN KILL BackupName
    IF _FILEEXISTS(Filename) THEN NAME Filename AS BackupName
    NAME TempName AS Filename
END SUB

SUB SortRanking
    DIM I AS LONG, J AS LONG, Temp AS PlayerRecord
    FOR I = 1 TO RecordCount - 1
        FOR J = I + 1 TO RecordCount
            IF Records(J).Wins > Records(I).Wins THEN
                Temp = Records(I)
                Records(I) = Records(J)
                Records(J) = Temp
            END IF
        NEXT J
    NEXT I
END SUB
