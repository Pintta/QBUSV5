QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('qb-dumpsearch:getItem', function(source, cb)
	local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local luck = math.random(1, 3)

    if luck == 2 then
        local luck2 = math.random(1, 4)
        local luck3 = math.random(1, 1000)
        local luck4 = math.random(1, 10000)
        
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local Amount = math.random(2,6)
        local ItemData = QBCore.Shared.Items["plastic"]

        if luck4 == 100 then	   
            ply.Functions.AddItem('weapon_snspistol', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_snspistol'], "add")  
        elseif luck3 == 1 then   
            ply.Functions.AddItem('weapon_stungun', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weapon_stungun'], "add")
            Player.Functions.AddItem(QBCore.Shared.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["plastic"], "add")
            Player.Functions.AddItem(QBCore.Shared.Items["steel"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["steel"], "add")         
        elseif luck2 == 1 then
            Player.Functions.AddItem(QBCore.Shared.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["plastic"], "add")
            Player.Functions.AddItem(QBCore.Shared.Items["steel"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["steel"], "add")
        else
            Player.Functions.AddItem(QBCore.Shared.Items["plastic"].name, Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["plastic"], "add")
        end		
        TriggerClientEvent('QBCore:Notify', src, 'Sterk, je hebt iets gevonden zwimpie', 'success', 2000)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je hebt niks gevonden zwimpie', 'error', 2000)
    end
end)

RegisterServerEvent('qb-dumpsearch:getItem')
AddEventHandler('qb-dumpsearch:getItem', function()
    QBCore.Functions.BanInjection(source, 'qb-dumpsearch (getItem)')
end)