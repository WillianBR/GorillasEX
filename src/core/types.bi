' GorillasEX - Tipos, constantes e estado compartilhado.
' Declaracoes explicitas; sem sufixos de tipo do QuickBASIC.
CONST GameVersion = "1.0.5"
CONST WorldHeight = 675
CONST GridSize = 4
CONST MaxGridX = 850
CONST MaxGridY = 169
CONST MaxPlayers = 2000
CONST Pi = 3.14159265358979323846
CONST FixedStep = .008333333333333333
TYPE GorillaState
    Name AS STRING
    X AS DOUBLE
    Y AS DOUBLE
    VelocityY AS DOUBLE
    Alive AS INTEGER
    Falling AS INTEGER
    FallStart AS DOUBLE
    Wins AS LONG
END TYPE
TYPE ProjectileState
    X AS DOUBLE
    Y AS DOUBLE
    PreviousX AS DOUBLE
    PreviousY AS DOUBLE
    VelocityX AS DOUBLE
    VelocityY AS DOUBLE
    Active AS INTEGER
    Owner AS INTEGER
END TYPE
TYPE PlayerRecord
    Name AS STRING
    Matches AS LONG
    Wins AS LONG
    Losses AS LONG
    Throws AS LONG
    Hits AS LONG
END TYPE
DIM SHARED ScreenWidth AS LONG, ScreenHeight AS LONG, WorldWidth AS LONG
DIM SHARED Terrain(0 TO MaxGridX, 0 TO MaxGridY) AS _UNSIGNED _BYTE
DIM SHARED Buildings(0 TO 100) AS LONG
DIM SHARED BuildingCount AS LONG
DIM SHARED Gorillas(1 TO 2) AS GorillaState
DIM SHARED Projectile AS ProjectileState
DIM SHARED Records(1 TO MaxPlayers) AS PlayerRecord
DIM SHARED RecordCount AS LONG
DIM SHARED SceneImage AS LONG
DIM SHARED CurrentPage AS LONG, SelectedMenu AS LONG, CurrentPlayer AS LONG
DIM SHARED RankingPage AS LONG, EditingPlayer AS LONG, NameBuffer AS STRING
DIM SHARED RoundNumber AS LONG, RoundLimit AS LONG
DIM SHARED Gravity AS DOUBLE, Wind AS DOUBLE, AimAngle AS DOUBLE, AimPower AS DOUBLE
' Preserva independentemente o ultimo ajuste de cada jogador.
DIM SHARED PlayerAimAngle(1 TO 2) AS DOUBLE
DIM SHARED PlayerAimPower(1 TO 2) AS DOUBLE
DIM SHARED MatchFinished AS INTEGER, RoundFinished AS INTEGER, RoundWinner AS LONG
DIM SHARED DemoMode AS INTEGER, ClassicMode AS INTEGER, SoundEnabled AS INTEGER
DIM SHARED ShowDebug AS INTEGER, QuitRequested AS INTEGER
DIM SHARED GameTime AS DOUBLE, FrameCounter AS LONG, FramesPerSecond AS LONG
' Marca o instante da vitoria para animar, sem bloquear o loop principal.
DIM SHARED VictoryStartedAt AS DOUBLE
' Pagina anterior ao help F1: permite retornar a partida sem reiniciar.
DIM SHARED HelpReturnPage AS LONG
' Arte opcional para o painel de ajuda.
DIM SHARED HelpImage AS LONG
DIM SHARED StatusText AS STRING, StatusUntil AS DOUBLE
DIM SHARED DataDirectory AS STRING
DIM SHARED SoundKind AS LONG, SoundPosition AS LONG, SoundSamples AS LONG
DIM SHARED AudioPhase AS DOUBLE, AudioSampleRate AS DOUBLE
DIM SHARED PrevMouseDown AS INTEGER, MouseClicked AS INTEGER
DIM SHARED MouseX AS DOUBLE, MouseY AS DOUBLE
DIM SHARED CitySeed AS LONG
' Dialogo de confirmacao: gerenciado pelo loop principal, sem chamadas Win32.
DIM SHARED ExitDialogVisible AS INTEGER
DIM SHARED ExitDialogSelection AS LONG

