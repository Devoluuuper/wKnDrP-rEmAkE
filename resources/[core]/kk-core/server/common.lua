KKF = {}
KKF.Players = {}
KKF.UsableItemsCallbacks = {}
KKF.CancelledTimeouts = {}
KKF.Pickups = {}
KKF.PickupId = 0
KKF.Jobs = {}

function getSharedObject()
	return KKF
end

MySQL.ready(function()
	local Jobs = {}

	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
		for k,v in ipairs(jobs) do
			Jobs[v.name] = v
			Jobs[v.name].grades = {}
			Jobs[v.name].properties = json.decode(v.properties)
		end

		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
			for k,v in ipairs(jobGrades) do
				if Jobs[v.job_name] then
					Jobs[v.job_name].grades[tostring(v.grade)] = v
					Jobs[v.job_name].grades[tostring(v.grade)].permissions = json.decode(v.permissions)
				else
					print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
				end
			end

			for k2,v2 in pairs(Jobs) do
				if KKF.Table.SizeOf(v2.grades) == 0 then
					Jobs[v2.name] = nil
					print(('[^3WARNING^7] Ignoring job ^5"%s"^0due to no job grades found'):format(v2.name))
				end
			end
			
			KKF.Jobs = Jobs
			KKF.StartDBSync()

			print("[kk-core] [^2INFO^7] Framework has been initialized!")
		end)
	end)
end)

RegisterServerEvent('KKF:clientLog')
AddEventHandler('KKF:clientLog', function(msg)
	print(('[^2TRACE^7] %s^7'):format(msg))
end)