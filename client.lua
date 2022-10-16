if Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
else
    ESX = exports['es_extended']:getSharedObject()
end

Utils = {
    ["qb"] = {
        ["Framework"] = Framework,
        ["TriggerCallback"] = function(name, func, ...)
            QBCore.Functions.TriggerCallback(name, func, ...)
        end,
        ["GetIdentifier"] = function()
            return QBCore.PlayerData.citizenid
        end,
        ["GetJob"] = function()
            return QBCore.PlayerData.job.name
        end,
    },
    ["esx"] = {
        ["Framework"] = Framework,
        ["TriggerCallback"] = function(name, func, ...)
            ESX.TriggerServerCallback(name, func, ...)
        end,
        ["GetIdentifier"] = function()
            return ESX.PlayerData.identifier
        end,
        ["GetJob"] = function()
            return ESX.PlayerData.job.name
        end,
    },
}

exports("Utils", function()
    return Utils[Framework]
end)