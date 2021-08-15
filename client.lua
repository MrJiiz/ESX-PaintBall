Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

local PBMarker = 
{
    DrawDistance = 30,
    Pos = vector3(201.033, -937.4637, 29.5783),
    Type = 1,
    Size = vector3(12.5, 12.5, 3.5),
    Color = { r = 255, g = 0, b = 0}
}

local isNearPB, isNearMarker = false, false
local isLBOpen = false
local isDead = false
local EquipGun = nil

local PBData = 
{
	LobbyId = -1,
	InPB = false,
	TeamID = 0,
	LastPos = 0,
	Teammates = {},
	MouseScroll = 0,
	CurrentRound = -1,
	MaxRounds = 0,
	armor = 0,
	rtime = 0,
	headbox = false,
	gunattachs = {},
}

local MapData =
{
	["bank"] =
	{
		["team1"] = { x = 244.43, y = 202.98, z = 105.21, h = 73.86 },
		["team2"] = { x = 254.34, y = 225.39, z = 106.29, h = 163.04 },
		["eteam1"] = { x = 222.06, y = 210.99, z = 105.55, h = 158.26 },
		["eteam2"] = { x = 220.76, y = 206.79, z = 105.47, h = 340.43 },
		["area"] = 
		{ 
			["Pos"] = { x = 249.33, y = 217.76, z = 100.29 },
			["Size"] = { x = 80.0, y = 80.0, z = 10.0 },
		},
	},
	["bimeh"] =
	{
		["team1"] = { x = -1085.06, y = -256.12, z = 37.76, h = 301.06 },
		["team2"] = { x = -1057.03, y = -239.54, z = 44.02, h = 115.0 },
		["eteam1"] = { x = -1088.07, y = -257.55, z = 37.76, h = 301.6 },
		["eteam2"] = { x = -1077.77, y = -247.37, z = 37.76, h = 112.74 },
		["area"] =
		{
			["Pos"] = { x = -1075.87, y = -243.6, z = 30.02 },
			["Size"] = { x = 90.0, y = 90.0, z = 20.0 },
		},
	},
	["cargo"] =
	{
		["team1"] = { x = -1022.21, y = 4937.08, z = 200.93, h = 143.32 },
		["team2"] = { x = -1093.72, y = 4942.15, z = 218.33, h = 158.38 },
		["eteam1"] = { x = -1096.51, y = 4906.76, z = 215.31, h = 331.95 },
		["eteam2"] = { x = -1093.16, y = 4914.79, z = 215.2, h = 156.72 },
		["area"] =
		{
			["Pos"] = { x = -1076.06, y = 4912.23, z = 150.97 },
			["Size"] = { x = 135.0, y = 135.0, z = 200.0 },
		},
	},	
	["skyscraper"] =
	{
		["team1"] = { x = -168.86, y = -1011.97, z = 254.13, h = 341.67 },
		["team2"] = { x = -139.52, y = -952.93, z = 254.13, h = 159.49 },
		["eteam1"] = { x = -161.05, y = -995.09, z = 254.13, h = 340.75 },
		["eteam2"] = { x = -158.08, y = -988.08, z = 254.13, h = 157.8 },
	},		
	["island"] =
	{
		["team1"] = { x = 244.43, y = 202.98, z = 105.21, h = 73.86 },
		["team2"] = { x = 254.34, y = 225.39, z = 106.29, h = 163.04 },
	},
	["javaheri"] =
	{
		["team1"] = { x = -657.12, y = -224.75, z = 37.73, h = 239.59 },
		["team2"] = { x = -624.62, y = -232.57, z = 38.06, h = 127.25 },
		["eteam1"] = { x = -642.56, y = -234.65, z = 37.86, h = 214.79 },
		["eteam2"] = { x = -634.0, y = -244.53, z = 38.28, h = 41.4 },
		["area"] =
		{
			["Pos"] = { x = -623.36, y = -231.63, z = 30.06 },
			["Size"] = { x = 80.0, y = 80.0, z = 40.0 },
		},
	},
	["shop1"] =
	{
		["team1"] = { x = 15.45, y = -1337.38, z = 30.28, h = 184.14 },
		["team2"] = { x = 26.56, y = -1344.42, z = 30.5, h = 176.61 },
		["eteam1"] = { x = 21.08, y = -1359.66, z = 30.34, h = 266.82 },
		["eteam2"] = { x = 36.08, y = -1359.75, z = 30.32, h = 88.62 },
		["area"] =
		{
			["Pos"] = { x = 28.88, y = -1345.42, z = 20.5 },
			["Size"] = { x = 32.0, y = 32.0, z = 50.0 },
		},
	},
	["shop2"] =
	{
		["team1"] = { x = -1212.56, y = -889.79, z = 13.86, h = 122.04 },
		["team2"] = { x = -1224.69, y = -906.18, z = 12.33, h = 30.27 },
		["eteam1"] = { x = -1224.24, y = -891.71, z = 13.43, h = 119.16 },
		["eteam2"] = { x = -1236.63, y = -898.79, z = 13.02, h = 300.62 },
		["area"] =
		{
			["Pos"] = { x = -1221.6, y = -911.33, z = 5.33 },
			["Size"] = { x = 70.0, y = 70.0, z = 50.0 },
		},
	},
	["1v1"] =
	{
		["team1"] = { x = -2100.9, y = 3095.54, z = 32.81, h = 332.33 },
		["team2"] = { x = -2074.5, y = 3141.4, z = 32.81, h = 148.7 },
		["eteam1"] = { x = -2100.78, y = 3095.96, z = 33.81, h = 327.91 },
		["eteam2"] = { x = -2096.8, y = 3102.9, z = 33.81, h = 158.88 },
		["area"] =
		{
			["Pos"] = { x = -2087.34, y = 3118.99, z = 15.71 },
			["Size"] = { x = 70.0, y = 70.0, z = 60.0 },
		},
	},
	["keshti"] =
	{
		["team1"] = {x= -2120.5451660156, y=-1006.7077026367, z= 7.96484375},
		["team2"] = {x= -2018.8088378906, y=-1039.6483154297, z= 2.4381103515625},
		["eteam1"] = {x= -2043.2967529297, y=-1029.4549560547, z= 11.97509765625},
		["eteam2"] = {x= -2044.5362548828, y=-1032.8835449219, z= 11.97509765625},
		["area"] =
		{
			["Pos"] = {x= -2065.1604003906, y=-1022.8879394531, z= 1.5787353515625},
			["Size"] = { x = 135.0, y = 135.0, z = 150.0 },
		},
	},
	["BankSheriff"] =
	{
		["team1"] = {x= -106.95824432373, y=6466.9448242188, z= 31.621948242188},
		["team2"] = {x= -97.02857208252, y=6479.5517578125, z= 31.234375},
		["eteam1"] = {x= -119.43296813965, y=6455.3276367188, z= 31.386108398438},
		["eteam2"] = {x= -117.74505615234, y=6453.349609375, z= 31.402954101563},
		["area"] =
		{
			["Pos"] = {x= -106.95824432373, y=6466.9448242188, z= 31.621948242188},
			["Size"] = { x = 60.0, y = 60.0, z = 50.0 },
		},
	},
	["jahanam"] =
	{
		["team1"] = {x= 120.47472381592, y=-753.00659179688, z= 250.29895019531},
		["team2"] = {x= 143.59121704102, y=-761.01098632813, z= 248.14208984375},
		["eteam1"] = {x= 153.60000610352, y=-732.85711669922, z= 250.14721679688},
		["eteam2"] = {x= 152.00439453125, y=-731.78900146484, z= 250.18090820313},
		["area"] =
		{
			["Pos"] = {x= 120.47472381592, y=-753.00659179688, z= 250.29895019531},
			["Size"] = { x = 90.0, y = 90.0, z = 50.0 },
		},
	},
	["vila"] =
	{
		["team1"] = {x= -162.21098327637, y=883.9384765625, z= 237.13916015625},
		["team2"] = {x= -142.95823669434, y=927.9296875, z= 235.62268066406},
		["eteam1"] = {x= -160.12747192383, y=903.25714111328, z= 242.19409179688},
		["eteam2"] = {x= -161.9736328125, y=905.06372070313, z= 242.19409179688},
		["area"] =
		{
			["Pos"] = {x= -161.9736328125, y=905.06372070313, z= 231.19116210938},
			["Size"] = { x = 70.0, y = 70.0, z = 50.0 },
		},
	},
	["club"] =
	{
		["team1"] = {x= 1578.0922851563, y=253.31867980957, z= -46.005126953125},
		["team2"] = {x= 1543.3319091797, y=244.3120880127, z= -49.021240234375},
		["eteam1"] = {x= 1559.841796875, y=248.24176025391, z= -49.021240234375},
		["eteam2"] = {x= 1560.052734375, y=249.73187255859, z= -49.021240234375},
		["area"] =
		{
			["Pos"] = {x= 1557.7583007813, y=249.50769042969, z= -49.021240234375},
			["Size"] = { x = 70.0, y = 70.0, z = 50.0 },
		},
	},
	["vault"] =
	{
		["team1"] = {x= 5.4857149124146, y=-661.26593017578, z= 16.1201171875},
		["team2"] = {x= 6.1318688392639, y=-707.64392089844, z= 16.1201171875},
		["eteam1"] = {x= -7.305492401123, y=-681.17803955078, z= 16.1201171875},
		["eteam2"] = {x= 2.6769232749939, y=-684.71209716797, z= 16.1201171875},
		["area"] =
		{
			["Pos"] = {x= -3.9428520202637, y=-686.16265869141, z= 16.1201171875},
			["Size"] = { x = 70.0, y = 70.0, z = 50.0 },
		},
	},
}

local TeamColors = 
{
	["team1"] = { r = 0, g = 0, b = 200 },
	["team2"] = { r = 255, g = 165, b = 0 }
}

local ClothesData =
{
	["team1"] =
	{
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 178,   torso_2 = 3,
			decals_1 = 0,   decals_2 = 0,
			arms = 35,
			pants_1 = 77,   pants_2 = 3,
			shoes_1 = 55,   shoes_2 = 3,
			mask_1  = 55,    mask_2  = 0,
			helmet_1 = 91,  helmet_2 = 3,
			bproof_1  = 0, bproof_2  = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0,
			bags_1 = 0,     bags_2 = 0,
			glasses_1 = 0,     glasses_2 = 2
		},
		female = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 180,   torso_2 = 3,
			decals_1 = 0,   decals_2 = 0,
			arms = 18,
			pants_1 = 79,   pants_2 = 3,
			shoes_1 = 58,   shoes_2 = 3,
			mask_1  = 48,    mask_2  = 1,
			helmet_1 = 90,  helmet_2 = 3,
			bproof_1  = 0, bproof_2  = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0,
			bags_1 = 0,     bags_2 = 0,
			glasses_1 = -1,     glasses_2 = 0
		}
	},
	["team2"] =
	{
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 178,   torso_2 = 5,
			decals_1 = 0,   decals_2 = 0,
			arms = 35,
			pants_1 = 77,   pants_2 = 5,
			shoes_1 = 55,   shoes_2 = 5,
			mask_1  = 55,    mask_2  = 0,
			helmet_1 = 91,  helmet_2 = 5,
			bproof_1  = 0, bproof_2  = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0,
			bags_1 = 0,     bags_2 = 0,
			glasses_1 = 0,     glasses_2 = 2
		},
		female = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1 = 180,   torso_2 = 5,
			decals_1 = 0,   decals_2 = 0,
			arms = 18,
			pants_1 = 79,   pants_2 = 5,
			shoes_1 = 58,   shoes_2 = 5,
			mask_1  = 48,    mask_2  = 1,
			helmet_1 = 90,  helmet_2 = 5,
			bproof_1  = 0, bproof_2  = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 0,     ears_2 = 0,
			bags_1 = 0,     bags_2 = 0,
			glasses_1 = -1,     glasses_2 = 0
		}
	}
}

local CleanSkin = {
	tshirt_1 = -1,  tshirt_2 = -1,
	torso_1 = -1,   torso_2 = -1,
	decals_1 = -1,   decals_2 = -1,
	arms = -1,
	pants_1 = -1,   pants_2 = -1,
	shoes_1 = -1,   shoes_2 = -1,
	mask_1  = -1,    mask_2  = -1,
	helmet_1 = -1,  helmet_2 = -1,
	bproof_1  = -1, bproof_2  = -1,
	chain_1 = -1,    chain_2 = -1,
	ears_1 = -1,     ears_2 = -1,
	glasses_1 = -1,     glasses_2 = -1
}

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(PBMarker.Pos.x, PBMarker.Pos.y, PBMarker.Pos.z)
    SetBlipSprite(blip, 543)
	SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 36)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("PaintBall")
    EndTextCommandSetBlipName(blip)

    while true do
        Citizen.Wait(5)
        if isNearPB then
            if isNearMarker and not isLBOpen then
                SetTextComponentFormat('STRING')
                AddTextComponentString('Press ~INPUT_CONTEXT~ To Open Lobby Menu')
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end
            DrawMarker(tonumber(PBMarker.Type), tonumber(PBMarker.Pos.x), tonumber(PBMarker.Pos.y), tonumber(PBMarker.Pos.z), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 2.0, tonumber(PBMarker.Color.r), tonumber(PBMarker.Color.g), tonumber(PBMarker.Color.b), 100, false, true, 2, false, false, false, false)
        elseif PBData.InPB then
            if MapData[PBData.MapName]["area"] then
                local AreaData = MapData[PBData.MapName]["area"]
                DrawMarker(tonumber(PBMarker.Type), tonumber(AreaData.Pos.x), tonumber(AreaData.Pos.y), tonumber(AreaData.Pos.z), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, tonumber(AreaData.Size.x), tonumber(AreaData.Size.y), tonumber(AreaData.Size.z), 0, 150, 0, 50, false, true, 2, false, false, false, false)
            end
        else
            if isLBOpen then
                OpenLobbyMenu(false)
                isLBOpen = false
            end
			
            Citizen.Wait(4000)
        end
			
		local playerPed = PlayerPedId()
		local myCoords = GetEntityCoords(playerPed)
		isNearPB = (GetDistanceBetweenCoords(myCoords, PBMarker.Pos) <= PBMarker.DrawDistance)
		if GetDistanceBetweenCoords(myCoords, PBMarker.Pos) < (PBMarker.Size.x / 2) then
			isNearMarker = true
		else
			isNearMarker = false
		end
    end
end)

RegisterKeyMapping('pbmenu', 'PaintBall Lobby Menu', 'keyboard', 'e')
RegisterCommand("pbmenu", function()() 
	if isNearMarker then
		if IsEntityDead(PlayerPedId()) then
			return
		end
		
		OpenLobbyMenu(true)
	end	
end)


function OpenLobbyMenu(state)
	SendNUIMessage({type = "show", show = state})
	SetNuiFocus(state, state)
	isLBOpen = state
	if state ~= nil then
		PBData.LobbyId = -1
	end
end

RegisterNUICallback('CreateLobby', function(data, cb)
	if not isNearPB then return end
	ESX.TriggerServerCallback('esx_paintball:CreateLobby', function(LobbyID)
		PBData.LobbyId = tonumber(LobbyID)
		cb(LobbyID)
	end, data)
end)

RegisterNetEvent('esx_paintball:JoinLobby')
AddEventHandler('esx_paintball:JoinLobby', function(TeamID, HTMLVal)
	SendNUIMessage({action = 'JoinTeam', team = TeamID, value = HTMLVal})
end)

RegisterNUICallback('QuitLobby', function(data, cb)
	if not isNearPB then return end
	OpenLobbyMenu(false)
	ESX.TriggerServerCallback('esx_paintball:QuitLobby', function(newData)
		cb(newData)
	end, data)
end)

RegisterNUICallback('ToggleReadyPlayer', function(data, cb)
	if not isNearPB then return end
	ESX.TriggerServerCallback('esx_paintball:ToggleReadyPlayer', function(newData)
		cb(newData)
	end, data)	
end)

RegisterNetEvent('esx_paintball:QuitLobby')
AddEventHandler('esx_paintball:QuitLobby', function(PlayerId)
	SendNUIMessage({action = 'LeftTeam', player = PlayerId})
end)

RegisterNetEvent('esx_paintball:ForceExit')
AddEventHandler('esx_paintball:ForceExit', function(LobbyId)
	if PBData.LobbyId == LobbyId then
		OpenLobbyMenu(false)
	end
end)

RegisterNUICallback('StartMatch', function(data, cb)
	if not isNearPB then return end
	ESX.TriggerServerCallback('esx_paintball:StartMatch', function(newData)
		cb(newData)
	end, data)	
end)

RegisterNetEvent('esx_paintball:StartMatch')
AddEventHandler('esx_paintball:StartMatch', function(LobbyId, mapName, weaponName, teamID, teammates, MaxRounds, Armor, RTime, gunattachs, headbox)
	if PBData.LobbyId == LobbyId then
		PBData.InPB = true
		PBData.TeamID = teamID
		PBData.LastPos = teamID
		PBData.MapName = mapName
		PBData.WeaponName = weaponName
		PBData.TeamPos = MapData[mapName]["team" .. teamID]				
		PBData.CurrentRound = 0
		PBData.MaxRounds = MaxRounds
		PBData.armor = Armor
		PBData.headbox = headbox
		PBData.gunattachs = gunattachs
		PBData.rtime = RTime
		
		Citizen.CreateThread(function()
			while PBData.InPB and PBData.LobbyId ~= -1 do
				Citizen.Wait(1000)
				if not isNearPB then
					local playerPed = PlayerPedId()
					if MapData[PBData.MapName]["area"] then
						local AreaData = MapData[PBData.MapName]["area"]
						if GetDistanceBetweenCoords(GetEntityCoords(playerPed), AreaData.Pos.x, AreaData.Pos.y, AreaData.Pos.z) > ((AreaData.Size.x / 2) + 3) then
							TriggerEvent('esx_paintball:ShowMessage', "~r~Out Of Zone", 120)
							Citizen.Wait(500)
							SetEntityHealth(playerPed, GetEntityHealth(playerPed) - 10)
						end
					end
				end
			end
		end)

		Citizen.CreateThread(function()
			while PBData.InPB do
			Citizen.Wait(1)
				DisableControlAction(2, Keys['F1'])		
				DisableControlAction(2, Keys['F2'])
				DisableControlAction(2, Keys['F3'])			
				DisableControlAction(2, Keys['F5'])
				DisableControlAction(2, Keys['F6'])
				DisableControlAction(2, Keys['F7'])			
				DisableControlAction(2, Keys['F9'])
				DisableControlAction(2, Keys['K'])
				DisableControlAction(2, Keys['G'])
				DisableControlAction(2, Keys['H'])
				DisableControlAction(2, Keys['~'])
				print(PBData.headbox)
				if PBData.headbox == 1 then
					SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
				else
					SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
				end
			end
		end)
		
		local myServerID = GetPlayerServerId(PlayerId())
		for k, v in pairs(teammates) do
			if v.source ~= myServerID then
				table.insert(PBData.Teammates, { source = v.source, player = GetPlayerFromServerId(v.source), name = GetPlayerName(GetPlayerFromServerId(v.source)), alive = true })
			end
		end
		OpenLobbyMenu(nil)	
		TriggerEvent('esx_paintball:inPaintBall', true)				
		TriggerServerEvent('esx_paintball:SetPlayerReqs', PBData.LobbyId--[[, GetPlayerLoadout()]])
		local clothesforapply = {}
		TriggerEvent('skinchanger:getSkin', function(skin)
			if tonumber(skin.sex) == 0 then
				clothesforapply = ClothesData["team" .. teamID].male
			elseif tonumber(skin.sex) == 1 then
				clothesforapply = ClothesData["team" .. teamID].female
			end
			
			if PBData.headbox == false then
				clothesforapply.helmet_1 = -1
				clothesforapply.helmet_2 = 0
				clothesforapply.mask_1 = -1
				clothesforapply.mask_2 = 0
			end
			
			TriggerEvent('skinchanger:loadClothes', skin, clothesforapply)
		end)
		
		Citizen.Wait(300)
		SendNUIMessage({action = "ShowGameHUD", value = true})			
		SendNUIMessage({action = "ResetRoundTimer", value = PBData.rtime, r = 0, g = 200, b = 0})						
		SendNUIMessage({action = "UpdateTeams", team1 = "0", team2 = "0"})		
		SendNUIMessage({action = "UpdateTotalRounds", value = "0", maxRounds = PBData.MaxRounds})
		GiveWeaponToPed(PlayerPedId(), GetHashKey(string.upper("weapon_"..weaponName)), 250, false, false)
		EquipGun = weaponName
		TriggerEvent('Paintball', true)
	end
end)

RegisterNUICallback('QuitFromMenu', function(data, cb)
	OpenLobbyMenu(false)
end)

RegisterNUICallback('LobbyList', function(data, cb)
	if not isNearPB then return end
	ESX.TriggerServerCallback('esx_paintball:GetLobbyList', function(Lobbies)
		cb(Lobbies)
	end, data)
end)

RegisterNUICallback('JoinLobby', function(data, cb)
	if not isNearPB then return end
	PBData.LobbyId = tonumber(data.LobbyId)
	ESX.TriggerServerCallback('esx_paintball:JoinLobby', function(Teams)
		cb(Teams)
	end, data)
end)

RegisterNUICallback('GetLobbyPassword', function(data, cb)
	if not isNearPB then return end
	ESX.TriggerServerCallback('esx_paintball:GetLobbyPassword', function(isCorrect)
		cb(isCorrect)
	end, data)	
end)

RegisterNUICallback('SwitchTeam', function(data, cb)
	if not isNearPB then return end
	ESX.TriggerServerCallback('esx_paintball:SwitchTeam', function(newData)
		cb(newData)
	end, data)	
end)

RegisterNetEvent('esx_paintball:RefreshPlayer')
AddEventHandler('esx_paintball:RefreshPlayer', function(LobbyId, PlayerId, TeamID, HTMLVal)
	if LobbyId == PBData.LobbyId then
		TriggerEvent('esx_paintball:QuitLobby', PlayerId)
		TriggerEvent('esx_paintball:JoinLobby', TeamID, HTMLVal)
	end
end)

RegisterNetEvent('esx_paintball:RefreshLobbies')
AddEventHandler('esx_paintball:RefreshLobbies', function(LobbyId)
	if isLBOpen then
		if PBData.LobbyId ~= LobbyId then
			SendNUIMessage({action = 'RefreshLobbies'})
		end
	end
end)

RegisterNetEvent('esx_paintball:UpdateTeams')
AddEventHandler('esx_paintball:UpdateTeams', function(LobbyId, teams, totalRounds)
	if PBData.LobbyId == LobbyId then
		SendNUIMessage({action = "UpdateTeams", team1 = tostring(teams[1]), team2 = tostring(teams[2])})
		SendNUIMessage({action = "UpdateTotalRounds", value = tostring(totalRounds), maxRounds = PBData.MaxRounds})
	end
end)

RegisterNetEvent('esx_paintball:StartRound')
AddEventHandler('esx_paintball:StartRound', function(LobbyId, RoundWinner)
	if PBData.LobbyId == LobbyId then
		SendNUIMessage({action = "ShowGameHUD", value = true})	
		SendNUIMessage({action = "ResetRoundTimer", value = PBData.rtime, r = 0, g = 200, b = 0})		
		TriggerEvent('master_weapons:ResetAll')
		
		for k, v in pairs(PBData.Teammates) do
			v.alive = true
		end
		
		if RoundWinner then
			local tempMsg = "~g~You win this round"		
			if RoundWinner ~= PBData.TeamID then tempMsg = "~r~Team " .. RoundWinner .. " won round" end		
			TriggerEvent('esx_paintball:ShowMessage', tempMsg)
			PBData.CurrentRound = PBData.CurrentRound + 1
		else
			PBData.CurrentRound = 0
		end
		
		local playerPed = PlayerPedId()
		RemoveAllPedWeapons(playerPed, true)
		
		if PBData.LastPos == 1 then
			PBData.LastPos = 2
		else
			PBData.LastPos = 1
		end

		PBData.TeamPos = MapData[PBData.MapName]["team" .. PBData.LastPos]
		
		RequestCollisionAtCoord(PBData.TeamPos.x, PBData.TeamPos.y, PBData.TeamPos.z + 0.05)		
		while not HasCollisionLoadedAroundEntity(playerPed) do
			RequestCollisionAtCoord(PBData.TeamPos.x, PBData.TeamPos.y, PBData.TeamPos.z + 0.05)
			Citizen.Wait(1)
		end	
		Citizen.Wait(1500)
		TriggerEvent('esx_ambulancejob:revive',source)	
		Citizen.Wait(500)
		SetEntityCoords(playerPed, PBData.TeamPos.x, PBData.TeamPos.y, PBData.TeamPos.z)
		RespawnPed(playerPed, PBData.TeamPos.x, PBData.TeamPos.y, PBData.TeamPos.z, PBData.TeamPos.h)
		Citizen.Wait(300)
		TriggerServerEvent('esx_paintball:StartRound', PBData.LobbyId)
		
		local player = PlayerId()
		local ped = PlayerPedId()
		
		SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
		TriggerEvent('holstersweapon:ForceStop')
		Citizen.Wait(500)
		
		SetEntityCollision(ped, true)
	    FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey(string.upper("weapon_"..EquipGun)), 250, false, false)
		local gunHash = GetHashKey(string.upper("weapon_"..EquipGun))
		SetEntityCoords(playerPed, PBData.TeamPos.x, PBData.TeamPos.y, PBData.TeamPos.z)
		print(PBData.armor)
		SetPedArmour(GetPlayerPed(-1), tonumber(PBData.armor))
		SetEntityHealth(playerPed, 200)
	end
end)

RegisterNetEvent('esx_paintball:QuitPaintBall')
AddEventHandler('esx_paintball:QuitPaintBall', function(LobbyId, PBWinner)
	if PBData.LobbyId == LobbyId then
		SendNUIMessage({action = "ResetRoundTimer", value = false})
		SendNUIMessage({action = "ShowGameHUD", value = false})
		SendNUIMessage({action = "UpdateTeams"})
		SendNUIMessage({action = "UpdateTotalRounds"})
		isDead = false
		Citizen.Wait(500)
		for k, v in pairs(GetActivePlayers()) do
			NetworkSetInSpectatorMode(false, GetPlayerPed(v))
		end
		
		Citizen.Wait(2500)
		TriggerEvent('esx_ambulancejob:revive',source)	
		Citizen.Wait(4500)
		local playerPed = PlayerPedId()
		
		SetEntityCoords(playerPed, PBMarker.Pos.x, PBMarker.Pos.y, PBMarker.Pos.z)		
		RemoveAllPedWeapons(playerPed, true)
		local gunHash = GetHashKey(string.upper("weapon_"..EquipGun))
		
		
		Citizen.Wait(300)
		
		TriggerServerEvent('esx_paintball:FinishPaintBall')
		
		local tempText = "~g~You won this match"
		if PBWinner ~= PBData.TeamID then
			tempText = "~r~Team " .. PBWinner .. " won match"
		end
		
		TriggerEvent('esx_paintball:ShowMessage', tempText)
		TriggerEvent('esx_paintball:inPaintBall', false)
		PBData.InPB = false
		PBData.TeamID = 0
		PBData.Teammates = {}
		PBData.MouseScroll = 0
		PBData.CurrentRound = -1
		PBData.MaxRounds = 0
		OpenLobbyMenu(false)
		SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
		TriggerEvent('Paintball', false)
		TriggerEvent('esx:restoreLoadout')
		TriggerEvent('skinchanger:loadSkin', CleanSkin)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			Citizen.Wait(100)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		TriggerEvent('master_weapons:ResetAll')
	end
end)

local BreakThatShit = false
RegisterNetEvent('esx_paintball:BringTogether')
AddEventHandler('esx_paintball:BringTogether', function(LobbyId, BringRound)
	if PBData.InPB and PBData.LobbyId == LobbyId then
		local playerPed = PlayerPedId()
		BreakThatShit = false
		local BringPos = MapData[PBData.MapName]["eteam" .. PBData.TeamID]
		SetEntityCoords(playerPed, BringPos.x, BringPos.y, BringPos.z)
		SetEntityHeading(playerPed, BringPos.h)
		TriggerEvent('esx_paintball:ShowMessage', "~r~Out Of Time!")
		local OFTWait = 10
		SendNUIMessage({action = "ResetRoundTimer", value = OFTWait, r = 200, g = 0, b = 0})
		Citizen.Wait(OFTWait * 1000)
		while true do
			if BreakThatShit then BreakThatShit = false return end			
			if not PBData.InPB or PBData.LobbyId ~= LobbyId or PBData.CurrentRound ~= BringRound then return end
			Citizen.Wait(math.random(500, 3000))
			SetEntityHealth(playerPed, GetEntityHealth(playerPed) - math.random(10, 15))
		end
	end
end)
RegisterCommand('kir',function(source)
	local playerPed = PlayerPedId()
		
	SetEntityCoords(playerPed, PBMarker.Pos.x, PBMarker.Pos.y, PBMarker.Pos.z)	
end)
RegisterNetEvent('esx_paintball:ShowMessage')
AddEventHandler('esx_paintball:ShowMessage', function(MsgText, setCounter)
	local scaleform = RequestScaleformMovie("mp_big_message_freemode")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextComponent("STRING")
	AddTextComponentString(MsgText)
	EndTextComponent()
	PopScaleformMovieFunctionVoid()	

	local counter = 0
	local maxCounter = (setCounter or 200)
	while counter < maxCounter do
		counter = counter + 1
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_paintball:GetPBData', function(cb)
	cb(PBData)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	BreakThatShit = true
	isDead = true
	if PBData.InPB and PBData.LobbyId ~= -1 then
		PBData.MouseScroll = 0
		TriggerServerEvent('esx_paintball:onPBDeath', PBData.LobbyId, data)
	end
end)

function GetWeaponLabel(weaponName)
	local weapons = ESX.GetWeaponList()
	for i=1, #weapons, 1 do
		if GetHashKey(weapons[i].name) == weaponName then
			return weapons[i].label
		end
	end
end

function GetTeammate(PlayerId)
	for k, v in pairs(PBData.Teammates) do
		if v.source == PlayerId then
			return k, v
		end
	end
	return nil, nil
end

RegisterNetEvent('esx_paintball:onPBDeath')
AddEventHandler('esx_paintball:onPBDeath', function(LobbyId, TeamID, data, victim, teamsCount, message)
	if PBData.InPB then
		if PBData.LobbyId == LobbyId then
			if message ~= nil then
				exports.pNotify:SendNotification({text = message, type = "error", layout = 'topRight', timeout = 8000})
			end
			if PBData.TeamID == TeamID then
				local tempMsg = "از تیم شما، " .. teamsCount[PBData.TeamID] .. " زنده می باشند."
				exports.pNotify:SendNotification({text = tempMsg, type = "info", timeout = 4000})
				if victim ~= GetPlayerServerId(PlayerId()) then
					local _, myTeammate = GetTeammate(victim)
					if myTeammate then
						PBData.Teammates[_].alive = false
					end
				end
			else
				local tempMsg = "از تیم حریف، " .. teamsCount[TeamID] .. " زنده می باشند."
				exports.pNotify:SendNotification({text = tempMsg, type = "info", timeout = 4000})
			end
		end
	end
end)

RegisterNetEvent('esx_paintball:PlayerDisconnected')
AddEventHandler('esx_paintball:PlayerDisconnected', function(LobbyId, PlayerId)
	if PBData.InPB then
		if PBData.LobbyId == LobbyId then
			local _, Teammate = GetTeammate(PlayerId)
			if Teammate then
				PBData.Teammates[_] = nil
			end
		end
	end
end)

function GetNextAliveTeammate(teammateID)
	for k, v in pairs(PBData.Teammates) do
		if v.alive then
			if k >= teammateID then
				return k, v.player
			end
		end
	end
	for k, v in pairs(PBData.Teammates) do
		if v.alive then
			return k, v.player
		end
	end
	return nil, nil
end

function RespawnPed(ped, x, y, z, heading)
	SetEntityCoordsNoOffset(ped, x, y, z, false, false, false, true)
	NetworkResurrectLocalPlayer(x, y, z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', x, y, z)
	ClearPedBloodDamage(ped)
	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('esx_paintball:setTopKillers')
AddEventHandler('esx_paintball:setTopKillers', function(LobbyId, topKillers)
	if PBData.LobbyId == LobbyId then
		SendNUIMessage({topKillers = topKillers})
	end
end)