' Sintetizador mono duplicado em estereo. Sem arquivos WAV/OGG externos.
' Nunca utiliza SOUND, PLAY, BEEP nem espera ocupada.
SUB StartSound (EffectNumber AS LONG)
    IF SoundEnabled = 0 THEN EXIT SUB
    IF AudioSampleRate <= 0 THEN EXIT SUB
    SoundKind = EffectNumber
    SoundPosition = 0
    SELECT CASE EffectNumber
        CASE 1: SoundSamples = AudioSampleRate * .24
        CASE 2: SoundSamples = AudioSampleRate * .15
        CASE 3: SoundSamples = AudioSampleRate * .55
        CASE 4: SoundSamples = AudioSampleRate * .85
        CASE ELSE: SoundSamples = AudioSampleRate * .10
    END SELECT
END SUB

SUB DrawAudio
    DIM Index AS LONG, SampleValue AS DOUBLE, Level AS DOUBLE
    DIM Frequency AS DOUBLE, PhaseStep AS DOUBLE, Noise AS DOUBLE
    IF SoundEnabled = 0 THEN EXIT SUB
    IF SoundKind = 0 THEN EXIT SUB
    ' Guarda preventiva: jamais calcula divisao com amostragem/duracao zero.
    IF AudioSampleRate <= 0 OR SoundSamples <= 0 THEN
        SoundKind = 0
        EXIT SUB
    END IF
    ' Limita a quantidade de PCM pendente, evitando latencia crescente.
    IF _SNDRAWLEN > .12 THEN EXIT SUB
    FOR Index = 1 TO 2048
        IF SoundPosition >= SoundSamples THEN
            SoundKind = 0
            EXIT FOR
        END IF
        Level = 1 - SoundPosition / SoundSamples
        SELECT CASE SoundKind
            CASE 1
                Frequency = 380 + 920 * (1 - Level)
                SampleValue = SIN(AudioPhase) * Level * .22
            CASE 2
                Frequency = 180 - 75 * (1 - Level)
                SampleValue = SIN(AudioPhase) * Level * .30
            CASE 3
                Frequency = 95 - 40 * (1 - Level)
                Noise = RND * 2 - 1
                SampleValue = (Noise * .31 + SIN(AudioPhase) * .18) * Level
            CASE 4
                ' Calcula primeiro o resto inteiro.
                ' Depois divide o resultado por 12.
                Frequency = 330 * (2 ^ ((INT((1 - Level) * 8) MOD 5) / 12))
                SampleValue = SIN(AudioPhase) * Level * .24
        END SELECT
        PhaseStep = 2 * Pi * Frequency / AudioSampleRate
        AudioPhase = AudioPhase + PhaseStep
        IF AudioPhase > 2 * Pi THEN AudioPhase = AudioPhase - 2 * Pi
        _SNDRAW SampleValue, SampleValue
        SoundPosition = SoundPosition + 1
    NEXT Index
END SUB
