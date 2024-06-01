Notify = function(title, msg, type)
    lib.notify({
      title = title,
      description = msg,
      type = type,
      position = X.NotifyPosition
    })
end
  
lib.callback.register('X-Banking:client:notify', function(title, msg, type)
    Notify(title, msg, type)
end)