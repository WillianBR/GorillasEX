' Configuracoes de tela e diretório persistente multiplataforma.
SUB InitDisplay
    SCREEN _NEWIMAGE(ScreenWidth, ScreenHeight, 32)
    _TITLE "GorillasEX - HD 32-bit - Powered by QB64-PE & @WillianBR"
    _FONT 16
END SUB

SUB ResizeDisplay (RequestedWidth AS LONG, RequestedHeight AS LONG)
    ' Recria a superficie sem reiniciar o mundo ou os jogadores.
    ScreenWidth = RequestedWidth
    ScreenHeight = RequestedHeight
    WorldWidth = INT(WorldHeight * ScreenWidth / ScreenHeight)
    IF WorldWidth > MaxGridX * GridSize THEN WorldWidth = MaxGridX * GridSize
    SCREEN _NEWIMAGE(ScreenWidth, ScreenHeight, 32)
    _FONT 16
    IF SceneImage < -1 THEN _FREEIMAGE SceneImage
    SceneImage = 0
    CreateCity
END SUB

SUB InitStorage
    DIM Root AS STRING
    Root = ENVIRON$("LOCALAPPDATA")
    IF Root = "" THEN
        Root = ENVIRON$("XDG_DATA_HOME")
        IF Root = "" THEN Root = ENVIRON$("HOME")
    END IF
    IF Root = "" THEN Root = "."
    DataDirectory = Root + "/GorillasEX"
    IF _DIREXISTS(DataDirectory) = 0 THEN MKDIR DataDirectory
END SUB
