if Config.Framework ~= "KKF" then
    return
end

while not KKF do
    Wait(500)
    debugprint("Services: Waiting for KKF to load")
end

---@return string
function GetJob()
    return KKF.PlayerData?.job?.name or "unemployed"
end

---@return number
function GetJobGrade()
    return KKF.PlayerData?.job?.grade or 0
end

RegisterNetEvent("KKF:setJob", function(job)
    local oldJob = KKF.PlayerData.job

    KKF.PlayerData.job = job

    if oldJob.name ~= job.name or oldJob.grade ~= job.grade then
        SendReactMessage("services:setCompany", GetCompanyData())
    else
        SendReactMessage("services:setDuty", job.onDuty)
    end

    TriggerEvent("lb-phone:jobUpdated", {
        job = job.name,
        grade = job.grade
    })
end)

function GetCompanyData()
    local companyData = {
        job = KKF.PlayerData.job.name,
        jobLabel = KKF.PlayerData.job.label,
        isBoss = KKF.PlayerData.job.grade_name == "boss",
        duty = KKF.PlayerData.job.onDuty
    }

    if not companyData.isBoss then
        for cId = 1, #Config.Companies.Services do
            local company = Config.Companies.Services[cId]

            if company.job == companyData.job then
                if not company.bossRanks then
                    break
                end

                companyData.isBoss = table.contains(company.bossRanks, KKF.PlayerData.job.grade_name)

                break
            end
        end
    end

    if not companyData.isBoss then
        return companyData
    end

    KKF.TriggerServerCallback("KKF_society:getSocietyMoney", function(money)
        companyData.balance = money
    end, companyData.job)

    KKF.TriggerServerCallback("KKF_society:getEmployees", function(employees)
        for i = 1, #employees do
            local employee = employees[i]

            employees[i] = {
                name = employee.name,
                id = employee.identifier,

                gradeLabel = employee.job.grade_label,
                grade = employee.job.grade,

                canInteract = employee.job.grade_name ~= "boss"
            }
        end

        companyData.employees = employees
    end, companyData.job)

    KKF.TriggerServerCallback("KKF_society:getJob", function(job)
        local grades = {}

        for i = 1, #job.grades do
            local grade = job.grades[i]

            grades[i] = {
                label = grade.label,
                grade = grade.grade
            }
        end

        companyData.grades = grades
    end, companyData.job)

    local timeout = GetGameTimer() + 2000

    while not companyData.balance or not companyData.employees or not companyData.grades do
        Wait(0)

        if GetGameTimer() > timeout then
            infoprint("error", "Failed to get company data (timed out after 2s)")
            print("balance: " .. tostring(companyData.balance))
            print("employees: " .. tostring(companyData.employees))
            print("grades: " .. tostring(companyData.grades))

            companyData.employees = companyData.employees or {}
            companyData.balance = companyData.balance or 0
            companyData.grades = companyData.grades or {}
            break
        end
    end

    return companyData
end

function DepositMoney(amount, cb)
    TriggerServerEvent("KKF_society:depositMoney", KKF.PlayerData.job.name, amount)
    Wait(500) -- Wait for the server to update the balance

    KKF.TriggerServerCallback("KKF_society:getSocietyMoney", cb, KKF.PlayerData.job.name)
end

function WithdrawMoney(amount, cb)
    TriggerServerEvent("KKF_society:withdrawMoney", KKF.PlayerData.job.name, amount)
    Wait(500) -- Wait for the server to update the balance

    KKF.TriggerServerCallback("KKF_society:getSocietyMoney", cb, KKF.PlayerData.job.name)
end

function HireEmployee(source, cb)
    local playersPromise = promise.new()

    KKF.TriggerServerCallback("KKF_society:getOnlinePlayers", function(players)
        playersPromise:resolve(players)
    end)

    local players = Citizen.Await(playersPromise)
    local player

    for i = 1, #players do
        if players[i].source == source then
            player = players[i]
            break
        end
    end

    if not player then
        return false
    end

    local hirePromise = promise.new()

    KKF.TriggerServerCallback("KKF_society:setJob", function()
        hirePromise:resolve(true)
    end, player.identifier, KKF.PlayerData.job.name, 0, "hire")

    if not Citizen.Await(hirePromise) then
        return
    end

    return {
        id = player.identifier,
        name = player.name,
    }
end

function FireEmployee(identifier, cb)
    local firePomise = promise.new()

    KKF.TriggerServerCallback("KKF_society:setJob", function()
        firePomise:resolve(true)
    end, identifier, "unemployed", 0, "fire")

    return Citizen.Await(firePomise)
end

function SetGrade(identifier, newGrade, cb)
    local promotePromise = promise.new()

    KKF.TriggerServerCallback("KKF_society:getJob", function(jobData)
        if newGrade > #jobData.grades - 1 then
            return cb(false)
        end

        KKF.TriggerServerCallback("KKF_society:setJob", function()
            promotePromise:resolve(true)
        end, identifier, KKF.PlayerData.job.name, newGrade, "promote")
    end, KKF.PlayerData.job.name)

    return Citizen.Await(promotePromise)
end

---@param duty boolean
function ToggleDuty(duty)
    TriggerServerEvent("phone:services:toggleDuty", duty)
end
