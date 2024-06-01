lib.locale()

CreateThread(function()
	if X.Framework == 'NEW_ESX' then
		ESX = exports['es_extended']:getSharedObject()
	elseif X.Framework == 'OLD_ESX' then
		ESX = nil

		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	else
		print('not correct framework!!')
	end
end)

lib.callback.register('X-Banking:server:getBalance', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	return (xPlayer and xPlayer.getAccount('bank').money or 0)
end)

lib.callback.register('X-Banking:server:withdraw', function(source, value)
	local xPlayer = ESX.GetPlayerFromId(source)
	local summa = tonumber(value)
	local balance = xPlayer.getAccount('bank').money
	if summa <= 0 or summa > balance then
		lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('errorvalue'), 'error')
	else
		xPlayer.removeAccountMoney('bank', summa)
		xPlayer.addMoney(summa)
		lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('withdrawn').. ': $' ..summa, 'success')
		Log(source, 'Withdraw', summa)
	end
end)

lib.callback.register('X-Banking:server:deposit', function(source, value)
	local xPlayer = ESX.GetPlayerFromId(source)
	local summa = tonumber(value)

	if summa <= 0 or summa > xPlayer.getMoney() then
		lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('errorvalue'), 'error')
	else
		xPlayer.removeMoney(summa)
		xPlayer.addAccountMoney('bank', summa)
		lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('deposited').. ': $' ..summa, 'success')
		Log(source, 'Deposit', summa)
	end
end)

lib.callback.register('X-Banking:server:transfer', function(source, value, player)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(player)
	local summa = tonumber(value)

	if summa <= 0 then
		lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('errorvalue'), 'error')
	elseif xTarget == nil or xTarget == -1 then
		lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('couldntfind'), 'error')
	elseif xPlayer.source == xTarget.source then
		lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('transfertoyu'), 'error')
	else
		local balance = xPlayer.getAccount('bank').money
		if balance <= 0 or balance < summa or summa <= 0 then
			lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('notenought'), 'error')
		else
			xPlayer.removeAccountMoney('bank', summa)
			lib.callback.await('X-Banking:client:notify', xPlayer.source, false, locale('successtransfer').. ': $' ..summa, 'success')
			Log(source, 'Transfer', summa)

			xTarget.addAccountMoney('bank', summa)
			lib.callback.await('X-Banking:client:notify', xTarget.source, false, locale('receivedtransfer').. ': $' ..summa, 'success')
		end
	end
end)