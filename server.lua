if Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
else
    ESX = exports['es_extended']:getSharedObject()
end

if GFXInventory then
    Inventory = exports["gfx-inventory"]
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
        ["HasMoney"] = function(player, account, amount)
            local pMoney = player.PlayerData.money[account]
            return pMoney >= amount
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
        ["GetItem"] = function(player, item)
            local itemData
            if GFXInventory then
                itemData = Inventory.GetItemByName(player.PlayerData.source, player.PlayerData.source, "inventory", item)
            else
                itemData = exports["qb-inventory"]:GetItemByName(player.PlayerData.source, item)
            end
            return itemData
        end,
        ["GetItemCount"] = function(player, item)
            local itemData
            if GFXInventory then
                itemData = Inventory.GetItemByName(player.PlayerData.source, player.PlayerData.source, "inventory", item)
            else
                itemData = exports["qb-inventory"]:GetItemByName(player.PlayerData.source, item)
            end
            itemData.amount = itemData.amount ~= nil and itemData.amount or itemData.count
            return itemData ~= nil and itemData.amount or 0
        end,
        ["GetInventory"] = function(player)
            return GFXInventory and Inventory.GetInventory(player.PlayerData.source, player.PlayerData.source) or player.PlayerData.items
        end,
        ["AddItem"] = function(player, item, count)
            if not GFXInventory then
                player.Functions.AddItem(item, count)
            else
                local src = player.PlayerData.source
                Inventory.AddItem(src, src, "inventory", item, count)
            end
        end,
        ["RemoveItem"] = function(player, item, count)
            if not GFXInventory then
                player.Functions.RemoveItem(item, count)
            else
                Inventory.RemoveItem(player.PlayerData.source, player.PlayerData.source, "inventory", item, count)
            end
        end,
        ["RandomInt"] = function(number)
            return QBCore.Shared.RandomInt(number)
        end,
        ["RandomStr"] = function(number)
            return QBCore.Shared.RandomStr(number)
        end,
        ["IsMod"] = function(player)
            return QBCore.Functions.HasPermission(player.PlayerData.source, "mod")
        end,
        ["IsAdmin"] = function(player)
            return QBCore.Functions.HasPermission(player.PlayerData.source, {"admin","god"})
        end,
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
            account = account == "cash" and "money" or account
            return player.addAccountMoney(account, money)
        end,
        ["HasMoney"] = function(player, account, amount)
            account = account == "cash" and "money" or account
            local pMoney = player.getAccount(account).money
            return pMoney >= amount
        end,
        ["RemoveMoney"] = function(player, account, money)
            account = account == "cash" and "money" or account
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
        ["GetItem"] = function(player, item)
            return GFXInventory and Inventory.GetItemByName(player.source, player.source, "inventory", item) or player.getInventoryItem(item)
        end,
        ["GetItemCount"] = function(player, item)
            local itemData = GFXInventory and Inventory.GetItemByName(player.source, player.source, "inventory", item) or player.getInventoryItem(item)
            return itemData ~= nil and itemData.count or 0
        end,
        ["GetInventory"] = function(player)
            return GFXInventory and Inventory.GetInventory(player.source, player.source) or player.inventory
        end,
        ["AddItem"] = function(player, item, count)
            if not GFXInventory then
                player.addInventoryItem(item, count)
            else
                Inventory.AddItem(player.source,player.source, "inventory", item, count)
            end
        end,
        ["RemoveItem"] = function(player, item, count)
            if not GFXInventory then
                player.removeInventoryItem(item, count)
            else
                Inventory.RemoveItem(player.source,player.source, "inventory", item, count)
            end
        end,
        ["RandomInt"] = function(number)
            return GetRandomNumber(number)
        end,
        ["RandomStr"] = function(number)
            return GetRandomLetter(number)
        end,
        ["IsMod"] = function(player)
            return player.getGroup() == "admin" or player.getGroup() == "mod"
        end,
        ["IsAdmin"] = function(player)
            return player.getGroup() == "admin"
        end,
    },
}

exports("Utils", function()
    return Utils[Framework]
end)
