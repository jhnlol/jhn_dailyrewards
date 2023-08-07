local Main = {

}
ESX = exports["es_extended"]:getSharedObject()
ESX.RegisterCommand('daily', {'user'}, function(xPlayer, args, showError)
    local player = source
    local currentDay = tonumber(os.date("%j"))
    local discord = ""
    local id = ""

    local identifiers = GetNumPlayerIdentifiers(xPlayer.source)
    for i = 0, identifiers - 1 do
        if GetPlayerIdentifier(xPlayer.source, i) ~= nil then
            if string.match(GetPlayerIdentifier(xPlayer.source, i), "discord") then
                discord = GetPlayerIdentifier(xPlayer.source, i)
                id = string.sub(discord, 9, -1)
            end
        end
    end

    MySQL.query('SELECT * FROM daily_rewards WHERE identifier = ?', { id }, function(response)
        if response then
            if response[1] then
                local lastRewardDay = tonumber(response[1].last_reward_day)
                local numRewards = tonumber(response[1].num_rewards)
                if lastRewardDay == currentDay then
                    xPlayer.showNotification("Odebrałeś już dzisiaj nagrodę.")
                else
                    numRewards = numRewards + 1
                    lastRewardDay = currentDay
                    if numRewards == 31 then 
                        xPlayer.showNotification('Odebrales juz wszystkie nagrody')
                    else 
                        local rewardData = Config.rewards[numRewards]
                        Main.UpdatePlayerRewards(id, lastRewardDay, numRewards)
                        xPlayer.addInventoryItem(rewardData.item, rewardData.count)
                        xPlayer.showNotification("Odebrałeś swoją codzienną nagrodę! Dostajesz nagrodę numer " .. numRewards .. ".")
                    end
                end
            else
                local numRewards = 1
                local lastRewardDay = currentDay
                local rewardData = Config.rewards[numRewards]
                xPlayer.addInventoryItem(rewardData.item, rewardData.count)
                MySQL.execute("INSERT INTO daily_rewards (identifier, last_reward_day, num_rewards) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE last_reward_day = VALUES(last_reward_day), num_rewards = VALUES(num_rewards)",
                {id, lastRewardDay, numRewards})
                xPlayer.showNotification("Odebrałeś swoją codzienną nagrodę! Dostajesz nagrodę numer 1.")
            end
        else
            xPlayer.showNotification("Wystąpił błąd podczas sprawdzania nagrody.")
        end
    end)
end, true, {help = "Odbierz codzienna nagrode", validate = true, arguments = {
}})
Main.UpdatePlayerRewards = function(playerIdent, lastRewardDay, numRewards)
    local updateQuery = string.format("UPDATE daily_rewards SET last_reward_day = %d, num_rewards = %d WHERE identifier = '%s'", lastRewardDay, numRewards, playerIdent)
    MySQL.execute(updateQuery)
end
