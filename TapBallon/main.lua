-- Ocultar la barra de estado
display.setStatusBar(display.HiddenStatusBar)

-- =========================================================================================
-- Variables de Configuración
-- =========================================================================================
local puntosPorToque = 2      
local velocidadInicial = 5    
local tiempoPorNivel = 30    
local puntosObjetivoBase = 10 -- Cambiado a 10 para que el Nivel 1 tenga un reto real

local nivel = 1
local puntuacion = 0
local tiempoRestante = tiempoPorNivel
local puntosObjetivo = puntosObjetivoBase
local velocidad = velocidadInicial
local direccionX = 1
local direccionY = 1
local juegoActivo = true

-- =========================================================================================
-- Elementos Visuales del Juego
-- =========================================================================================
local fondo = display.newImageRect("Fondo.png", display.contentWidth, display.contentHeight)
fondo.x = display.contentCenterX
fondo.y = display.contentCenterY 

local marcadorPuntos = display.newText("Puntos: 0 / " .. puntosObjetivo, 100, 40, native.systemFont, 25)
local marcadorTiempo = display.newText("Tiempo: " .. tiempoRestante, display.contentWidth - 100, 40, native.systemFont, 25)
local marcadorNivel = display.newText("Nivel: 1", display.contentCenterX, 80, native.systemFont, 20)

local circulo = display.newImageRect("Circulo.png", 120, 120)
circulo.x = display.contentCenterX
circulo.y = display.contentCenterY
local radio = 60

-- =========================================================================================
-- Pantalla de Fin de Juego (Grupo estilo Canva)
-- =========================================================================================
local grupoFinJuego = display.newGroup()

local franjaTitulo = display.newRect(grupoFinJuego, display.contentCenterX, 50, display.contentWidth, 60)
local tituloTxt = display.newText(grupoFinJuego, "TapBallon", display.contentCenterX, 50, native.systemFontBold, 40)
tituloTxt:setFillColor(0, 0, 0)

local marcadorFinal = display.newText(grupoFinJuego, "Puntuaje: 0", display.contentCenterX, 200, native.systemFont, 35)
marcadorFinal:setFillColor(0,0,0) -- Color negro para el puntaje final

local franjaCentro = display.newRect(grupoFinJuego, display.contentCenterX, display.contentCenterY, display.contentWidth, 200)
local textoResultado = display.newText(grupoFinJuego, "Perdiste", display.contentCenterX, display.contentCenterY, native.systemFontBold, 90)
textoResultado:setFillColor(0, 0, 0)

local btnReiniciar = display.newText(grupoFinJuego, "Volver a intentar", display.contentCenterX, display.contentHeight - 150, native.systemFont, 30)
btnReiniciar:setFillColor(1, 1, 1) -- Blanco para que resalte sobre el verde del fondo

grupoFinJuego.isVisible = false 

-- =========================================================================================
-- Funciones de Lógica
-- =========================================================================================

local function moverCirculo(event)
    if juegoActivo then
        circulo.x = circulo.x + (velocidad * direccionX)
        circulo.y = circulo.y + (velocidad * direccionY)

        if circulo.x >= display.contentWidth - radio or circulo.x <= radio then direccionX = -direccionX end
        if circulo.y >= display.contentHeight - radio or circulo.y <= radio then direccionY = -direccionY end
    end
end

-- Función para MOSTRAR Pantalla Final (Ganador o Perdedor)
local function finalizarJuego(estado)
    juegoActivo = false
    circulo.isVisible = false
    grupoFinJuego.isVisible = true
    
    -- OCULTAR marcadores superiores
    marcadorPuntos.isVisible = false
    marcadorTiempo.isVisible = false
    marcadorNivel.isVisible = false

    marcadorFinal.text = "Puntuaje Total: " .. puntuacion
    
    if estado == "ganado" then
        textoResultado.text = "Ganasteee"
        textoResultado:setFillColor(0, 0.6, 0) -- Verde victoria
        franjaCentro:setFillColor(0.8, 1, 0.8) -- Franja verde claro
    else
        textoResultado.text = "Perdiste"
        textoResultado:setFillColor(0.8, 0, 0) -- Rojo derrota
        franjaCentro:setFillColor(1, 1, 1)     -- Franja blanca normal
    end
end

local function siguienteNivel()
    if nivel < 5 then
        nivel = nivel + 1
        puntuacion = 0
        tiempoRestante = tiempoPorNivel
        velocidad = velocidadInicial + (nivel * 2) 
        puntosObjetivo = puntosObjetivoBase + (nivel * 10) -- Sube de 10 en 10
        
        marcadorNivel.text = "Nivel: " .. nivel
        marcadorPuntos.text = "Puntos: 0 / " .. puntosObjetivo
    else
        finalizarJuego("ganado")
    end
end

local function tocarCirculo(event)
    if event.phase == "began" and juegoActivo then
        puntuacion = puntuacion + puntosPorToque 
        marcadorPuntos.text = "Puntos: " .. puntuacion .. " / " .. puntosObjetivo
        
        circulo.x = math.random(radio, display.contentWidth - radio)
        circulo.y = math.random(radio, display.contentHeight - radio)

        if puntuacion >= puntosObjetivo then
            siguienteNivel()
        end
    end
end

local function actualizarReloj()
    if juegoActivo then
        tiempoRestante = tiempoRestante - 1
        marcadorTiempo.text = "Tiempo: " .. tiempoRestante
        if tiempoRestante <= 0 then finalizarJuego("perdido") end
    end
end

-- Función para REINICIAR (RESET TOTAL)
local function reiniciarJuego(event)
    if event.phase == "began" then
        -- 1. Reset de variables
        nivel = 1
        puntuacion = 0
        velocidad = velocidadInicial
        tiempoRestante = tiempoPorNivel
        puntosObjetivo = puntosObjetivoBase
        juegoActivo = true
        
        -- 2. Reset de Interfaz (Colores y Textos)
        textoResultado:setFillColor(0, 0, 0) 
        franjaCentro:setFillColor(1, 1, 1)    
        marcadorNivel.text = "Nivel: 1"
        marcadorPuntos.text = "Puntos: 0 / " .. puntosObjetivo
        marcadorTiempo.text = "Tiempo: " .. tiempoRestante
        
        -- 3. Mostrar marcadores y ocultar pantalla final
        marcadorPuntos.isVisible = true
        marcadorTiempo.isVisible = true
        marcadorNivel.isVisible = true
        grupoFinJuego.isVisible = false
        circulo.isVisible = true
        circulo.x = display.contentCenterX
        circulo.y = display.contentCenterY
        
        return true
    end
end

-- =========================================================================================
-- Registro de Eventos
-- =========================================================================================
Runtime:addEventListener("enterFrame", moverCirculo)
circulo:addEventListener("touch", tocarCirculo)
btnReiniciar:addEventListener("touch", reiniciarJuego)

timer.performWithDelay(1000, actualizarReloj, 0)