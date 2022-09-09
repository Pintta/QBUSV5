mumbleConfig = {
    voiceModes = {
        {2.5, "Whisper"},
        {8, "Normal"},
        {20, "Scream"},
    },
    speakerRange = 1.5,
    callSpeakerEnabled = true,
    radioSpeakerEnabled = true,
    radioEnabled = true,
    micClicks = true,
    micClickOn = true,
    micClickOff = true,
    micClickVolume = 0.1,
    radioClickMaxChannel = 100,
    controls = {
        proximity = {
            key = 20, -- Z
        },
        radio = {
            pressed = false,
            key = 137, -- capital
        },
        speaker = {
            key = 20, -- Z
            secondary = 21, -- LEFT SHIFT
        }
    },
    radioChannelNames = {
        [1] = "Police 1",
        [2] = "Police 2",
        [3] = "Ambulance 1",
        [4] = "Ambulance 2",
    }
}

function SetMumbleProperty(key, value)
	if mumbleConfig[key] ~= nil and mumbleConfig[key] ~= "controls" and mumbleConfig[key] ~= "radioChannelNames" then
		mumbleConfig[key] = value
	end
end

function AddRadioChannelName(channel, name)
    local channel = tonumber(channel)
    if channel ~= nil and name ~= nil and name ~= "" then
        if not mumbleConfig.radioChannelNames[channel] then
            mumbleConfig.radioChannelNames[channel] = tostring(name)
        end
    end
end

exports("SetMumbleProperty", SetMumbleProperty)
exports("SetTokoProperty", SetMumbleProperty)
exports("AddRadioChannelName", AddRadioChannelName)
