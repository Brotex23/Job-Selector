ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)  

local display = false


function job()
    SendNUIMessage({
        type = "clearjob",
    })
        for k,v in pairs(Config.JobsList) do
            SendNUIMessage({
                type = 'add',
                title = v.title,
                img = v.img,
                lvl = v.lvl,
                players = v.players,
                time = v.time,
                jobdescription = v.jobdescription,
                titleimg1 = v.titleimg1,
                titleimg2 = v.titleimg2,
                jobconfirmtitle = v.jobconfirmtitle,
                jobconfirmtext = v.jobconfirmtext,
                jobname = v.jobname,
                jobselectortitle = v.jobselectortitle,
                jobselectortext = v.jobselectortext,
            }) 
    end
end



function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) 
        DisableControlAction(0, 2, display) 
        DisableControlAction(0, 142, display) 
        DisableControlAction(0, 18, display) 
        DisableControlAction(0, 322, display) 
        DisableControlAction(0, 106, display) 
    end
end)

RegisterNUICallback('getjob', function(data, cb)
    TriggerServerEvent("job-selector:setjob", data.jobname)
    SetDisplay(false)
end)

RegisterNUICallback('exit', function()
    SetDisplay(false)
end)

function showHelpNotification(message)
    AddTextEntry('HelpNotification', message)
    DisplayHelpTextThisFrame('HelpNotification', false)
end


-----------------------------
--      BLIP               --
-----------------------------

local blip = AddBlipForCoord(vector3(-264.9626, -963.9429, 31.21753))
	
SetBlipSprite(blip, 408)  -- What Blip? https://docs.fivem.net/docs/game-references/blips/
SetBlipScale (blip, 1.0)  -- Blip Size
SetBlipColour(blip, 56)   -- Blip Color
SetBlipAsShortRange(blip, true)
	 
BeginTextCommandSetBlipName('STRING')
AddTextComponentSubstringPlayerName('Job Center')  -- Blip Name
EndTextCommandSetBlipName(blip)

-----------------------------
--      QTARGET            --
-----------------------------

local peds = {
    `s_m_m_highsec_02`,
}
        exports["qtarget"]:AddTargetModel(peds, {
            options = {
                {
                    event = "brotex:open",
                    icon = "fas fa-globe", -- https://fontawesome.com/search?q=money&p=2&o=r
                    label = "Job Center!",
					num = 1
                },
			
             },
             job = {"all"},
            distance = 2.0
        })

        

RegisterNetEvent('brotex:open')
AddEventHandler('brotex:open', function()
    job()
    SetDisplay(true)
end)

-----------------------------
--           PED           --
----------------------------- 

-- https://docs.fivem.net/docs/game-references/ped-models/#multiplayer

peddd = {
	{'s_m_m_highsec_02'--[[HASH]], -265.3451--[[X COORDS]], -963.033 --[[Y COORDS]],30.21753--[[Z COORDS]],223.937--[[HEADING]]},
  }
  
  Citizen.CreateThread(function()
	for _,v in pairs(peddd) do
	  RequestModel(GetHashKey(v[1]))
	  while not HasModelLoaded(GetHashKey(v[1])) do
		Wait(1)
	  end

	  JobPed =  CreatePed(4, v[1],v[2],v[3],v[4],v[5], false, true)
	  FreezeEntityPosition(JobPed, true) 
	  SetEntityInvincible(JobPed, true) 
	  SetBlockingOfNonTemporaryEvents(JobPed, true) 
	end
end)