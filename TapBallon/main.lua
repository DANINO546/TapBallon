
-- Ocultar la barra de estado
display.setStatusBar(display.HiddenStatusBar)

-- Variables globales
local puntuacion = 0
local velocidad = 5  -- Velocidad inicial del circulo
local direccionX = 1
local direccionY = 1

-- Agregar fondo
local fondo = display.newImageRect("Fondo.png", display.contentWidth, display.contentHeight)
fondo.x = display.contentCenterX
fondo.y = display.contentCenterY

-- Agregar marcador de puntuacion
local marcador = display.newText("Puntos: 0", display.contentCenterX, 40, native.systemFont, 30)
marcador:setFillColor(0,0,0) -- Color blanco

-- Crear el circulo en movimiento
local circulo = display.newImageRect("Circulo.png", 80, 80)
circulo.x = math.random(80, display.contentWidth - 80)
circulo.y = math.random(80, display.contentHeight - 80)

-- Función para mover el circulo
local function moverCirculo(event)
    circulo.x = circulo.x + (velocidad * direccionX)
    circulo.y = circulo.y + (velocidad * direccionY)

    -- Rebotar en los bordes de la pantalla
    if circulo.x >= display.contentWidth - 40 or circulo.x <= 40 then
        direccionX = -direccionX
    end

    if circulo.y >= display.contentHeight - 40 or circulo.y <= 40 then
        direccionY = -direccionY
    end
end

-- Función al tocar el circulo
local function tocarCirculo(event)
    if event.phase == "began" then
        puntuacion = puntuacion + 1
        marcador.text = "Puntos: " .. puntuacion
        circulo.x = math.random(80, display.contentWidth - 80)
        circulo.y = math.random(80, display.contentHeight - 80)

        -- Aumentar velocidad cada 10 puntos
        if puntuacion % 1 == 0 then
            velocidad = velocidad + 5
        end
    end
end

-- Agregar eventos
Runtime:addEventListener("enterFrame", moverCirculo) -- Movimiento continuo
circulo:addEventListener("touch", tocarCirculo) -- Evento de toque