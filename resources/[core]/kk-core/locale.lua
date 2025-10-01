Locales = {}

function _(str, ...)  -- Translate string

	if Locales[Config.Locale] ~= nil then

		if Locales[Config.Locale][str] ~= nil then
			return string.format(Locales[Config.Locale][str], ...)
		else
			return 'Tõlge [' .. Config.Locale .. '][' .. str .. '] ei eksisteeri!'
		end

	else
		return 'Tõlge [' .. Config.Locale .. '] ei eksisteeri'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end
