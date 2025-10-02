local JSON = json.decode(LoadResourceFile(GetCurrentResourceName(), "/config.json"))

lib.callback.register('brp-pursuitmodes:getModes', function(source)
    return JSON
end)