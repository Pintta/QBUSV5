QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code

RegisterNetEvent('rs-vehicleshop:server:buyVehicle')
AddEventHandler('rs-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    QBCore.Functions.BanInjection(source, 'rs-vehicleshop (buyVehicle)')
end)

QBCore.Functions.CreateCallback('rs-vehicleshop:buyVehicle', function(source, cb, vehicleData, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = QBCore.Shared.Vehicles[vehicleData["model"]]
    local balance = pData.PlayerData.money["bank"]
    
    if (balance - vData["price"]) >= 0 then
        local plate = GeneratePlate()
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData["model"].."', '"..GetHashKey(vData["model"]).."', '{}', '"..plate.."', '"..garage.."')")
        TriggerClientEvent("QBCore:Notify", src, "Success! Je voertuig is afgeleverd bij "..QB.GarageLabel[garage], "success", 5000)
        pData.Functions.RemoveMoney('bank', vData["price"], "vehicle-bought-in-shop")
        TriggerEvent("rs-log:server:sendLog", cid, "vehiclebought", {model=vData["model"], name=vData["name"], from="garage", location=QB.GarageLabel[garage], moneyType="bank", price=vData["price"], plate=plate})
        TriggerEvent("rs-log:server:CreateLog", "vehicleshop", "Voertuig gekocht (garage)", "green", "**"..GetPlayerName(src) .. "** heeft een " .. vData["name"] .. " gekocht voor €" .. vData["price"])
    else
		TriggerClientEvent("QBCore:Notify", src, "Je hebt niet voldoende geld, je mist €"..format_thousand(vData["price"] - balance), "error", 5000)
    end
end)

RegisterNetEvent('rs-vehicleshop:server:buyShowroomVehicle')
AddEventHandler('rs-vehicleshop:server:buyShowroomVehicle', function(vehicle, class)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = QBCore.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (balance - vehiclePrice) >= 0 then
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vehicle.."', '"..GetHashKey(vehicle).."', '{}', '"..plate.."', 0)")
        TriggerClientEvent("QBCore:Notify", src, "Success! Je voertuig staat buiten te op je te wachten.", "success", 5000)
        TriggerClientEvent('rs-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
        TriggerEvent("rs-log:server:sendLog", cid, "vehiclebought", {model=vehicle, name=QBCore.Shared.Vehicles[vehicle]["name"], from="showroom", moneyType="bank", price=QBCore.Shared.Vehicles[vehicle]["price"], plate=plate})
        TriggerEvent("rs-log:server:CreateLog", "vehicleshop", "Voertuig gekocht (showroom)", "green", "**"..GetPlayerName(src) .. "** heeft een " .. QBCore.Shared.Vehicles[vehicle]["name"] .. " gekocht voor €" .. QBCore.Shared.Vehicles[vehicle]["price"])
    else
        TriggerClientEvent("QBCore:Notify", src, "Je hebt niet voldoende geld, je mist €"..format_thousand(vehiclePrice - balance), "error", 5000)
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterServerEvent('rs-vehicleshop:server:setShowroomCarInUse')
AddEventHandler('rs-vehicleshop:server:setShowroomCarInUse', function(showroomVehicle, bool)
    QB.ShowroomVehicles[showroomVehicle].inUse = bool
    TriggerClientEvent('rs-vehicleshop:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('rs-vehicleshop:server:setShowroomVehicle')
AddEventHandler('rs-vehicleshop:server:setShowroomVehicle', function(vData, k)
    QB.ShowroomVehicles[k].chosenVehicle = vData
    TriggerClientEvent('rs-vehicleshop:client:setShowroomVehicle', -1, vData, k)
end)

RegisterServerEvent('rs-vehicleshop:server:SetCustomShowroomVeh')
AddEventHandler('rs-vehicleshop:server:SetCustomShowroomVeh', function(vData, k)
    QB.ShowroomVehicles[k].vehicle = vData
    TriggerClientEvent('rs-vehicleshop:client:SetCustomShowroomVeh', -1, vData, k)
end)

QBCore.Commands.Add("verkoop", "Verkoop voertuig uit Custom Cardealer", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        if TargetId ~= nil then
            TriggerClientEvent('rs-vehicleshop:client:SellCustomVehicle', source, TargetId)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Je moet een Speler ID meegeven!', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'Je bent geen Voertuig Dealer', 'error')
    end
end)

QBCore.Commands.Add("testrit", "Testrit maken", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        TriggerClientEvent('rs-vehicleshop:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('QBCore:Notify', source, 'Je bent geen Voertuig Dealer', 'error')
    end
end)

RegisterServerEvent('rs-vehicleshop:server:SellCustomVehicle')
AddEventHandler('rs-vehicleshop:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('rs-vehicleshop:client:SetVehicleBuying', TargetId, ShowroomSlot)
end)

RegisterServerEvent('rs-vehicleshop:server:ConfirmVehicle')
AddEventHandler('rs-vehicleshop:server:ConfirmVehicle', function(ShowroomVehicle)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local VehPrice = QBCore.Shared.Vehicles[ShowroomVehicle.vehicle].price
    local plate = GeneratePlate()

    if Player.PlayerData.money.cash >= VehPrice then
        Player.Functions.RemoveMoney('cash', VehPrice)
        TriggerClientEvent('rs-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    elseif Player.PlayerData.money.bank >= VehPrice then
        Player.Functions.RemoveMoney('bank', VehPrice)
        TriggerClientEvent('rs-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.vehicle.."', '"..GetHashKey(ShowroomVehicle.vehicle).."', '{}', '"..plate.."', 0)")
    else
        if Player.PlayerData.money.cash > Player.PlayerData.money.bank then
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld.. Je mist ('..(Player.PlayerData.money.cash - VehPrice)..',-)')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet voldoende geld.. Je mist ('..(Player.PlayerData.money.bank - VehPrice)..',-)')
        end
    end
end)

QBCore.Functions.CreateCallback('rs-vehicleshop:server:SellVehicle', function(source, cb, vehicle, plate)
    local VehicleData = QBCore.Shared.VehicleModels[vehicle]
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Player.Functions.AddMoney('bank', math.ceil(VehicleData["price"] / 100 * 60))
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'")
            cb(true)
        else
            cb(false)
        end
    end)
end)