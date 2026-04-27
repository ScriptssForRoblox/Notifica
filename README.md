# 📦 gold™ UI Library

Biblioteca modular de UI para scripts Roblox. Composta por 3 módulos independentes.

---

## 📁 Arquivos

| Arquivo | Descrição |
|---|---|
| `Notification.lua` | Notificações toast com tipos e barra de progresso |
| `Loading.lua` | Tela de loading com barra animada |
| `CreateTab.lua` | Interface com abas, botões, toggles e sliders |

---

## 🔔 Notification.lua

### Carregar
```lua
local Notify = loadstring(game:HttpGet("[URL_DO_NOTIFICATION](https://raw.githubusercontent.com/ScriptssForRoblox/Notifica/refs/heads/main/Notification.lua)"))()
```

### Enviar notificação
```lua
Notify.Send({
    title    = "gold™",
    message  = "Script carregado com sucesso!",
    duration = 5,
    type     = "success",  -- "info" | "success" | "warning" | "error" | "default"
    icon     = nil         -- opcional: URL de imagem customizada
})
```

### Tipos disponíveis
| Tipo | Cor |
|---|---|
| `default` | Roxo |
| `info` | Azul |
| `success` | Verde |
| `warning` | Amarelo |
| `error` | Vermelho |

### Exemplo completo
```lua
local Notify = loadstring(game:HttpGet("URL"))()

Notify.Send({ title = "Carregando", message = "Iniciando script...", type = "info", duration = 4 })
Notify.Send({ title = "Sucesso", message = "Script ativo!", type = "success", duration = 5 })
Notify.Send({ title = "Erro", message = "Falha ao conectar.", type = "error", duration = 6 })
```

---

## ⏳ Loading.lua

### Carregar
```lua
local Loading = loadstring(game:HttpGet("URL_DO_LOADING"))()
```

### Mostrar loading
```lua
local screen = Loading.Show({
    title   = "gold™",
    message = "Carregando módulos...",
    accent  = Color3.fromRGB(160, 100, 255)  -- opcional
})
```

### Atualizar texto enquanto carrega
```lua
screen.SetStatus("Conectando ao servidor...")
screen.SetMessage("Aguarde, isso pode demorar.")
```

### Esconder loading
```lua
Loading.Hide()
```

### Exemplo completo
```lua
local Loading = loadstring(game:HttpGet("URL"))()

local screen = Loading.Show({ title = "gold™", message = "Inicializando..." })

screen.SetStatus("Carregando mapa...")
task.wait(2)

screen.SetStatus("Conectando...")
task.wait(1)

Loading.Hide()
```

---

## 🗂️ CreateTab.lua

### Carregar
```lua
local UI = loadstring(game:HttpGet("URL_DO_CREATETAB"))()
```

### Criar janela
```lua
local window = UI.CreateWindow({
    title  = "gold™",
    accent = Color3.fromRGB(160, 100, 255)  -- opcional
})
```

> A janela é **arrastável** pelo topbar e tem botão de **minimizar**.

### Criar aba
```lua
local tab = window.CreateTab("Main")
```

### Adicionar elementos

#### Label (texto de seção)
```lua
tab.AddLabel("Configurações")
```

#### Botão
```lua
tab.AddButton({
    text     = "Executar",
    callback = function()
        print("Clicou!")
    end
})
```

#### Toggle
```lua
tab.AddToggle({
    text     = "Ativar ESP",
    default  = false,
    callback = function(state)
        print("ESP:", state)
    end
})
```

#### Slider
```lua
tab.AddSlider({
    text     = "Velocidade",
    min      = 0,
    max      = 100,
    default  = 16,
    callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
```

### Exemplo completo
```lua
local UI = loadstring(game:HttpGet("URL"))()

local window = UI.CreateWindow({ title = "gold™" })

local main = window.CreateTab("Main")
local settings = window.CreateTab("Settings")

main.AddLabel("Combate")
main.AddToggle({ text = "Aimbot", default = false, callback = function(v) print(v) end })
main.AddButton({ text = "Kill All", callback = function() print("kill all") end })

settings.AddLabel("Player")
settings.AddSlider({ text = "WalkSpeed", min = 16, max = 200, default = 16, callback = function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end })
```

---

## 🔗 Usar tudo junto

```lua
local Notify  = loadstring(game:HttpGet("URL_NOTIFICATION"))()
local Loading = loadstring(game:HttpGet("URL_LOADING"))()
local UI      = loadstring(game:HttpGet("URL_CREATETAB"))()

-- Loading enquanto carrega
local screen = Loading.Show({ title = "gold™", message = "Carregando..." })
screen.SetStatus("Iniciando módulos...")
task.wait(2)
Loading.Hide()

-- Notificação de boas vindas
Notify.Send({ title = "gold™", message = "Script carregado!", type = "success", duration = 5 })

-- Interface
local window = UI.CreateWindow({ title = "gold™" })
local tab = window.CreateTab("Main")
tab.AddButton({ text = "Teste", callback = function()
    Notify.Send({ title = "Ação", message = "Botão clicado!", type = "info", duration = 3 })
end })
```

---

> Feito por **gold™**
