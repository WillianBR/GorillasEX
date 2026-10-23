' GorillasEX v1.0.0 - Jogo de artilharia retro em QB64 Phoenix Edition.
' Copyright (c) 2026. Implementacao independente inspirada em Gorillas.
' Codigo multiplataforma, RGBA 32-bit, sem recursos exclusivos de MS-DOS.
' Cada subsistema vive em seu proprio arquivo .bi.

' Habilita informacoes de origem para erros em tempo de execucao.
$ERRORLOCATION:ON

' Exige declaracao explicita das variaveis.
OPTION _EXPLICIT
 
' Tipos de retorno das FUNCTION sem sufixos de QuickBASIC.
' QB64-PE nao aceita "FUNCTION Nome(...) AS Tipo".
' As diretivas DEF... aplicam-se somente a identificadores sem AS explicito.
' Funcao BuildingColor usa LONG com o mesmo padrao de bits RGBA.
DEFINT I
DEFLNG B, E, F, J, P
DEFDBL R
DEFSTR S

' GorillasEX - Identidade visual da aplicacao.
' Incorpora o icone ao executavel Windows.
$EXEICON:'./assets/icons/GorillasEX.ico'

'$INCLUDE:'core/types.bi'

' Inicializacao do processo e de todos os sistemas.
RANDOMIZE TIMER
ScreenWidth = 1280
ScreenHeight = 720
WorldWidth = INT(WorldHeight * ScreenWidth / ScreenHeight)
Gravity = 300
RoundLimit = 5
SoundEnabled = -1
AudioSampleRate = 44100
CurrentPage = 0
SelectedMenu = 1
CitySeed = CLNG(TIMER * 1000) AND &H7FFFFFFF
InitDisplay
InitStorage
LoadRanking
CreateCity
InitPlayers

' O loop nunca bloqueia esperando animacoes ou sons terminarem.
DIM PreviousTime AS DOUBLE, NowTime AS DOUBLE, DeltaTime AS DOUBLE
DIM Accumulator AS DOUBLE, KeyText AS STRING, LoopCount AS LONG
PreviousTime = TIMER(.001)
DO WHILE QuitRequested = 0
    _LIMIT 60
    NowTime = TIMER(.001)
    DeltaTime = NowTime - PreviousTime
    IF DeltaTime < 0 THEN DeltaTime = DeltaTime + 86400
    IF DeltaTime > .15 THEN DeltaTime = .15
    PreviousTime = NowTime
    GameTime = GameTime + DeltaTime
    PollMouse
    KeyText = INKEY$
    HandleInput KeyText
    IF CurrentPage = 1 AND MatchFinished = 0 THEN
        Accumulator = Accumulator + DeltaTime
        LoopCount = 0
        DO WHILE Accumulator >= FixedStep AND LoopCount < 18
            UpdatePhysics FixedStep
            Accumulator = Accumulator - FixedStep
            LoopCount = LoopCount + 1
        LOOP
    ELSE
        Accumulator = 0
    END IF
    IF CurrentPage = 0 THEN DrawMenu
    IF CurrentPage = 1 THEN DrawGame
    IF CurrentPage = 2 THEN DrawRanking
    IF CurrentPage = 3 THEN DrawHelp
    IF CurrentPage = 4 THEN DrawNameEditor
    DrawAudio
    _DISPLAY
LOOP
SaveRanking
IF SceneImage < -1 THEN _FREEIMAGE SceneImage
SYSTEM

' Bibliotecas logicas: implementacoes apos o programa principal.
'$INCLUDE:'platform/platform.bi'
'$INCLUDE:'graphics/renderer.bi'
'$INCLUDE:'graphics/buildings.bi'
'$INCLUDE:'graphics/sprites.bi'
'$INCLUDE:'core/game.bi'
'$INCLUDE:'core/physics.bi'
'$INCLUDE:'audio/sound.bi'
'$INCLUDE:'storage/ranking.bi'
'$INCLUDE:'input/input.bi'
'$INCLUDE:'ui/screens.bi'
