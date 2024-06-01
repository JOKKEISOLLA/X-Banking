ESX = exports['es_extended']:getSharedObject()
lib.locale()

CreateThread(function()
  if X.Framework == 'NEW_ESX' then
    ESX = exports['es_extended']:getSharedObject()
  elseif X.Framework == 'OLD_ESX' then
    ESX = nil

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
  else
    return
  end
end)

OpenAtm = function()
  local balance = lib.callback.await('X-Banking:server:getBalance', false)
  lib.registerContext({
    id = 'atm',
    title = locale('atm'),
    options = {
      {
        title = locale('balance').. ': $' ..balance,
        icon = X.Currency,
      },
      {
        title = locale('withdraw'),
        icon = X.Currency,
        arrow = true,
        onSelect = OpenInput,
        args = {
          withdraw = true
        }
      },
      {
        title = locale('deposit'),
        icon = X.Currency,
        arrow = true,
        onSelect = OpenInput,
        args = {
          deposit = true
        }
      },
      {
        title = locale('transfer'),
        icon = X.Currency,
        arrow = true,
        onSelect = OpenInput,
        args = {
          transfer = true
        }
      },
    }
  })
  lib.showContext('atm')
end

OpenBank = function()
  local balance = lib.callback.await('X-Banking:server:getBalance', false)
  lib.registerContext({
    id = 'bank',
    title = locale('bank'),
    options = {
      {
        title = locale('balance').. ': $' ..balance,
        icon = X.Currency,
      },
      {
        title = locale('withdraw'),
        icon = X.Currency,
        arrow = true,
        onSelect = OpenInput,
        args = {
          withdraw = true
        }
      },
      {
        title = locale('deposit'),
        icon = X.Currency,
        arrow = true,
        onSelect = OpenInput,
        args = {
          deposit = true
        }
      },
      {
        title = locale('transfer'),
        icon = X.Currency,
        arrow = true,
        onSelect = OpenInput,
        args = {
          transfer = true
        }
      },
    }
  })
  lib.showContext('bank')
end

OpenInput = function(args)
  local balance = lib.callback.await('X-Banking:server:getBalance', false)
  if args.withdraw then
    local input = lib.inputDialog(locale('withdraw'), {
      {type = 'input', label = locale('howmuch'), icon = X.Currency, required = true},
    })

    if input then
    local value = input[1]
    lib.callback.await('X-Banking:server:withdraw', false, value)
    else
      return
    end
  elseif args.deposit then
    local input = lib.inputDialog(locale('deposit'), {
      {type = 'input', label = locale('howmuch'), icon = X.Currency, required = true},
    })

    if input then
    local value = input[1]
    lib.callback.await('X-Banking:server:deposit', false, value)
    else 
      return
    end
  elseif args.transfer then
    local transfer = lib.inputDialog(locale('transfer'), {
      {type = 'input', label = locale('howmuch'), icon = X.Currency, required = true},
      {type = 'input', label = locale('id'), icon = 'fas fa-user', required = true},
    })

    if transfer then
      local value1 = transfer[1]
      local value2 = transfer[2]
      lib.callback.await('X-Banking:server:transfer', false, value1, value2)
    else
      return
    end
  end
end

CreateThread(function()
    exports.qtarget:AddTargetModel(X.ATMProps, {
        options = {{
            icon = 'fas fa-credit-card',
            label = locale('atm'),
            action = OpenAtm
        }},
        distance = 1.5
  })

  for k,v in pairs(X.BankZones) do
    local name = ('Bank_%s'):format(k)
    exports.qtarget:AddBoxZone(name, v.pos, v.length, v.width,
      {
        name = name,
        heading = v.h,
        minZ = v.minZ,
        maxZ = v.maxZ
      }, {
        options = {{
          icon = 'fas fa-money-bill-wave',
          label = locale('bank'),
          action = OpenBank
        }},
        distance = 2.0
      }
    )
  end
end)