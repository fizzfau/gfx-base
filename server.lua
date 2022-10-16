if Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
else
    ESX = exports['es_extended']:getSharedObject()
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Wait(0)
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Wait(0)
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end


Utils = {
    ["qb"] = {
        ["Framework"] = Framework,
        ["GetPlayer"] = function(src)
            return QBCore.Functions.GetPlayer(src)
        end,
        ["GetPlayerIndex"] = function(index)
            return QBCore.Functions.GetPlayerByCitizenId(index)
        end,
        ["AddMoney"] = function(player, account, money)
            return player.Functions.AddMoney(account, money)
        end,
        ["RemoveMoney"] = function(player, account, money)
            return player.Functions.RemoveMoney(account, money)
        end,
        ["Notify"] = function(src, text)
            return QBCore.Functions.Notify(src, text)
        end,
        ["CreateCallback"] = function(name, func)
            return QBCore.Functions.CreateCallback(name, func)
        end,
        ["GetIdentifier"] = function(player)
            return player.PlayerData.citizenid
        end,
        ["GetJob"] = function(player)
            return player.PlayerData.job.name
        end,
        ["AddItem"] = function(player, item, count)
            player.Functions.AddItem(item, count)
        end,
        ["RemoveItem"] = function(player, item, count)
            player.Functions.RemoveItem(item, count)
        end,
        ["RandomInt"] = function(number)
            return QBCore.Shared.RandomInt(number)
        end,
        ["RandomStr"] = function(number)
            return QBCore.Shared.RandomStr(number)
        end
    },
    ["esx"] = {
        ["Framework"] = Framework,
        ["GetPlayer"] = function(src)
            return ESX.GetPlayerFromId(src)
        end,
        ["GetPlayerIndex"] = function(index)
            return ESX.GetPlayerFromIdentifier(index)
        end,
        ["AddMoney"] = function(player, account, money)
            return player.addAccountMoney(account, money)
        end,
        ["RemoveMoney"] = function(player, account, money)
            return player.removeAccountMoney(account, money)
        end,
        ["Notify"] = function(src, text)
            local player = ESX.GetPlayerFromId(src)
            return player.showNotification(text)
        end,
        ["CreateCallback"] = function(name, func)
            return ESX.RegisterServerCallback(name, func)
        end,
        ["GetIdentifier"] = function(player)
            return player.identifier
        end,
        ["GetJob"] = function(player)
            return player.job.name
        end,
        ["AddItem"] = function(player, item, count)
            player.addInventoryItem(item, count)
        end,
        ["RemoveItem"] = function(player, item, count)
            player.addInventoryItem(item, count)
        end,
        ["RandomInt"] = function(number)
            return GetRandomNumber(number)
        end,
        ["RandomStr"] = function(number)
            return GetRandomLetter(number)
        end
    },
}

exports("Utils", function()
    return Utils[Framework]
end)