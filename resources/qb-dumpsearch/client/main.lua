QBCore = nil

local PlayerData = {}
local isLoggedIn = false
local percent    = false
local searching  = false

cachedBins = {}

closestBin = {
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b'
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    isLoggedIn = true
end)


DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i = 1, #closestBin do
            local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
            local entity = nil
            if DoesEntityExist(x) then
                sleep  = 5
                entity = x
                bin    = GetEntityCoords(entity)
                DrawText3Ds(bin.x, bin.y, bin.z + 2.0, '[~g~E~w~] om dumpster te doorzoeken')  
                if IsControlJustReleased(0, 38) then
                    if not cachedBins[entity] then
                        openBin(entity)
                    else
						
                        QBCore.Functions.Notify('Ga andere vuilnisbak zoeken zwimpie',"error", 3500)
                    end
                end
                break
            else
                sleep = 1000
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do

        local sleep = 1000

        if percent then

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for i = 1, #closestBin do

                local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
                local entity = nil
                
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    bin    = GetEntityCoords(entity)
                    DrawText3Ds(bin.x, bin.y, bin.z + 1.5, TimeLeft .. '~g~%~s~')
                    break
                end
            end
        end
        Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if searching then
            DisableControlAction(0, 73) 
        end
    end
end)

openBin = function(entity)
    QBCore.Functions.Progressbar("search_register", "Graaien..", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@prop_human_bum_bin@base",
        anim = "base",
        flags = 50,
    }, {}, {}, function() -- Done
        searching = true
        cachedBins[entity] = true
        QBCore.Functions.TriggerCallback('qb-dumpsearch:getItem', function(result)
        end)
        ClearPedTasks(PlayerPedId())
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@base", "base", 1.0)
        searching = false  
    end, function() -- Cancel
        GetMoney = false
        StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@base", "base", 1.0)
        ClearPedTasks(GetPlayerPed(-1))
        QBCore.Functions.Notify("Proces Canceled..", "error")
    end)
	
end