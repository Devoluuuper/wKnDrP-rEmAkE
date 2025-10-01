ESX = exports['kk-core'].getSharedObject()

RegisterNetEvent('kk-scripts:server:kickPlayer')
on('kk-scripts:server:kickPlayer', () => {
    let xPlayer = ESX.GetPlayerFromId(source);

    if (xPlayer) {
        if (!xPlayer.isAdmin()) {
            DropPlayer(xPlayer.source, 'Olite liiga kaua eemal!')
        }
    } else {
        DropPlayer(xPlayer.source, 'Olite liiga kaua eemal!')
    }
})