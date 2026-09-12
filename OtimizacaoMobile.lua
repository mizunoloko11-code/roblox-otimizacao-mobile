--[[
    ╔════════════════════════════════════════════════════════════╗
    ║          OTIMIZAÇÃO MOBILE - SCRIPT ROBLOX               ║
    ║     Interface Limpa e Leve para Dispositivos Móveis      ║
    ║                                                            ║
    ║  Compatível com Executores | Lua 5.1+                   ║
    ║  Otimizado para Performance em Celular                   ║
    ╚════════════════════════════════════════════════════════════╝
]]

-- ╔════════════════════════════════════════════════════════════╗
-- ║                    VARIÁVEIS GLOBAIS                       ║
-- ╚════════════════════════════════════════════════════════════╝

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local NetworkReplicator = game:GetService("NetworkReplicator")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Estados das otimizações
local states = {
	otimizacaoGeral = false,
	otimizacaoCampo = false,
	bolaBlanca = false,
	bolaVermelha = false,
	pingReduzido = false
}

-- Objetos original para restauração
local originalParts = {}
local guiCreated = false

-- ╔════════════════════════════════════════════════════════════╗
-- ║              FUNÇÕES DE OTIMIZAÇÃO                        ║
-- ╚════════════════════════════════════════════════════════════╝

-- Função: Otimização Geral
local function toggleOtimizacaoGeral()
	states.otimizacaoGeral = not states.otimizacaoGeral
	
	if states.otimizacaoGeral then
		-- Remove texturas
		for _, part in pairs(workspace:FindPartBoundsInRadius(camera.CFrame.Position, 500)) do
			if part:IsA("BasePart") then
				pcall(function()
					if not originalParts[part] then
						originalParts[part] = {
							texture = part.Texture,
							material = part.Material,
							reflectance = part.Reflectance
						}
					end
					part.Material = Enum.Material.SmoothPlastic
					part.Texture = ""
					part.Reflectance = 0
				end)
			end
		end
		
		-- Reduz qualidade de efeitos
		local lighting = game:GetService("Lighting")
		lighting.Brightness = math.max(0.5, lighting.Brightness - 0.3)
		
		-- Desativa sombras
		pcall(function()
			lighting.GlobalShadows = false
		end)
		
		print("✅ Otimização Geral: ATIVADA")
	else
		-- Restaura texturas
		for part, original in pairs(originalParts) do
			if part and part.Parent then
				pcall(function()
					part.Material = original.material
					part.Texture = original.texture
					part.Reflectance = original.reflectance
				end)
			end
		end
		
		-- Restaura iluminação
		local lighting = game:GetService("Lighting")
		lighting.Brightness = 2
		pcall(function()
			lighting.GlobalShadows = true
		end)
		
		originalParts = {}
		print("❌ Otimização Geral: DESATIVADA")
	end
end

-- Função: Otimização de Campo
local function toggleOtimizacaoCampo()
	states.otimizacaoCampo = not states.otimizacaoCampo
	
	if states.otimizacaoCampo then
		-- Procura por linhas do campo
		local field = workspace:FindFirstChild("Field") or workspace:FindFirstChild("Pitch") or workspace:FindFirstChild("Soccer")
		
		if field then
			for _, child in pairs(field:GetDescendants()) do
				if child:IsA("BasePart") then
					pcall(function()
						-- Reduz detalhes do campo
						if string.find(child.Name:lower(), "line") or string.find(child.Name:lower(), "mark") then
							if not originalParts[child] then
								originalParts[child] = { transparency = child.Transparency }
							end
							child.Transparency = 0.7 -- Torna semi-transparente
						end
					end)
				end
			end
		end
		
		print("✅ Otimização Campo: ATIVADA")
	else
		-- Restaura campo
		for part, original in pairs(originalParts) do
			if part and part.Parent and string.find(part.Name:lower(), "line") then
				pcall(function()
					part.Transparency = original.transparency or 0
				end)
			end
		end
		print("❌ Otimização Campo: DESATIVADA")
	end
end

-- Função: Bola Branca
local function toggleBolaBlanca()
	states.bolaBlanca = not states.bolaBlanca
	states.bolaVermelha = false -- Desativa bola vermelha
	
	if states.bolaBlanca then
		-- Procura pela bola
		local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball") or workspace:FindFirstChild("Bola")
		
		if ball then
			if ball:IsA("BasePart") then
				if not originalParts[ball] then
					originalParts[ball] = {
						color = ball.Color,
						material = ball.Material,
						texture = ball.Texture
					}
				end
				
				ball.Color = Color3.fromRGB(255, 255, 255) -- Branco puro
				ball.Material = Enum.Material.SmoothPlastic
				ball.Texture = ""
			end
		end
		
		print("⚪ Bola Branca: ATIVADA")
	else
		-- Restaura bola original
		local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball") or workspace:FindFirstChild("Bola")
		if ball and originalParts[ball] then
			pcall(function()
				ball.Color = originalParts[ball].color
				ball.Material = originalParts[ball].material
				ball.Texture = originalParts[ball].texture
			end)
		end
		print("❌ Bola Branca: DESATIVADA")
	end
end

-- Função: Bola Vermelha
local function toggleBolaVermelha()
	states.bolaVermelha = not states.bolaVermelha
	states.bolaBlanca = false -- Desativa bola branca
	
	if states.bolaVermelha then
		-- Procura pela bola
		local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball") or workspace:FindFirstChild("Bola")
		
		if ball then
			if ball:IsA("BasePart") then
				if not originalParts[ball] then
					originalParts[ball] = {
						color = ball.Color,
						material = ball.Material,
						texture = ball.Texture
					}
				end
				
				ball.Color = Color3.fromRGB(255, 0, 0) -- Vermelho puro
				ball.Material = Enum.Material.SmoothPlastic
				ball.Texture = ""
			end
		end
		
		print("🔴 Bola Vermelha: ATIVADA")
	else
		-- Restaura bola original
		local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball") or workspace:FindFirstChild("Bola")
		if ball and originalParts[ball] then
			pcall(function()
				ball.Color = originalParts[ball].color
				ball.Material = originalParts[ball].material
				ball.Texture = originalParts[ball].texture
			end)
		end
		print("❌ Bola Vermelha: DESATIVADA")
	end
end

-- Função: Ping Reduzido
local function togglePingReduzido()
	states.pingReduzido = not states.pingReduzido
	
	if states.pingReduzido then
		-- Reduz taxa de envio de dados
		pcall(function()
			if NetworkReplicator then
				-- Otimiza sincronização de rede
				game:FindFirstChild("NetworkClient"):SetProperty("SendRate", 20)
			end
		end)
		
		-- Reduz FPS para economizar banda
		RunService:Set3DRenderingEnabled(true)
		
		print("📡 Ping Reduzido: ATIVADA (Taxa otimizada)")
	else
		print("❌ Ping Reduzido: DESATIVADA")
	end
end

-- ╔════════════════════════════════════════════════════════════╗
-- ║                   INTERFACE GRÁFICA                       ║
-- ╚════════════════════════════════════════════════════════════╝

local function createGUI()
	if guiCreated then return end
	guiCreated = true
	
	-- Cria ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "OtimizacaoMobileGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")
	
	-- Define tamanho para mobile
	if UserInputService.TouchEnabled then
		screenGui.Size = UDim2.new(0, 300, 0, 450)
	else
		screenGui.Size = UDim2.new(0, 320, 0, 500)
	end
	
	-- Painel Principal
	local mainPanel = Instance.new("Frame")
	mainPanel.Name = "MainPanel"
	mainPanel.Size = UDim2.new(1, 0, 1, 0)
	mainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	mainPanel.BorderSizePixel = 0
	mainPanel.Parent = screenGui
	
	-- Barra de Título
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 50)
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainPanel
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "⚙️ Otimização Mobile"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = titleBar
	
	-- Container de Botões
	local buttonContainer = Instance.new("ScrollingFrame")
	buttonContainer.Name = "ButtonContainer"
	buttonContainer.Size = UDim2.new(1, 0, 1, -50)
	buttonContainer.Position = UDim2.new(0, 0, 0, 50)
	buttonContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	buttonContainer.BorderSizePixel = 0
	buttonContainer.ScrollBarThickness = 8
	buttonContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 450)
	buttonContainer.Parent = mainPanel
	
	-- Layout
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 10)
	uiListLayout.Parent = buttonContainer
	
	-- Função para criar botão
	local function createButton(title, callback, index)
		local button = Instance.new("TextButton")
		button.Name = title
		button.Size = UDim2.new(1, -20, 0, 50)
		button.Position = UDim2.new(0, 10, 0, 10 + (index - 1) * 60)
		button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		button.BorderSizePixel = 0
		button.Text = "◯ " .. title
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.TextScaled = true
		button.Font = Enum.Font.Gotham
		button.Parent = buttonContainer
		
		-- Efeito de hover
		local mouseEntered = false
		button.MouseEnter:Connect(function()
			mouseEntered = true
			button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
		end)
		
		button.MouseLeave:Connect(function()
			mouseEntered = false
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		end)
		
		-- Click
		button.MouseButton1Click:Connect(function()
			callback()
			
			-- Atualiza indicador
			local stateName = title:gsub(" ", "")
			if string.find(title, "Otimização Geral") then
				button.Text = (states.otimizacaoGeral and "🟢 " or "🔴 ") .. title
			elseif string.find(title, "Otimização Campo") then
				button.Text = (states.otimizacaoCampo and "🟢 " or "🔴 ") .. title
			elseif string.find(title, "Bola Branca") then
				button.Text = (states.bolaBlanca and "🟢 " or "🔴 ") .. title
			elseif string.find(title, "Bola Vermelha") then
				button.Text = (states.bolaVermelha and "🟢 " or "🔴 ") .. title
			elseif string.find(title, "Ping Reduzido") then
				button.Text = (states.pingReduzido and "🟢 " or "🔴 ") .. title
			end
		end)
		
		-- Corner radius
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = button
	end
	
	-- Cria botões
	createButton("✅ Otimização Geral", toggleOtimizacaoGeral, 1)
	createButton("🎮 Otimização Campo", toggleOtimizacaoCampo, 2)
	createButton("⚪ Bola Branca", toggleBolaBlanca, 3)
	createButton("🔴 Bola Vermelha", toggleBolaVermelha, 4)
	createButton("📡 Ping Reduzido", togglePingReduzido, 5)
	
	-- Botão de Fechar
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(1, -20, 0, 40)
	closeButton.Position = UDim2.new(0, 10, 0, 420)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "✕ Fechar"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = buttonContainer
	
	closeButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
		guiCreated = false
	end)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = closeButton
	
	print("✅ Interface GUI criada com sucesso!")
end

-- ╔════════════════════════════════════════════════════════════╗
-- ║                  INICIALIZAÇÃO                            ║
-- ╚════════════════════════════════════════════════════════════╝

-- Aguarda o player carregar
if player then
	wait(1)
	createGUI()
	print("🚀 Otimização Mobile carregada!")
	print("💡 Dica: Ajuste as opções conforme sua necessidade!")
else
	print("❌ Erro: Player não encontrado")
end

-- Cleanup ao sair
player.CharacterAdded:Connect(function()
	wait(2)
	-- Reaplica otimizações se estavam ativas
	if states.otimizacaoGeral then
		toggleOtimizacaoGeral()
		wait(0.2)
		toggleOtimizacaoGeral()
	end
end)