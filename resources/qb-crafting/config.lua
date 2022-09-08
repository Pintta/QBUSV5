Config = {}
--["location"] = {x = 3520.94, y = 3705.84, z = 20.76, h = 156.5, r = 1.0}, 
Config.AttachmentCrafting = {
    ["location"] = {x = 3618.32, y = 3730.28, z = 28.69, h = 156.5, r = 1.0}, 
    ["items"] = {
        [1] = {
            name = "pistol_extendedclip",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 1, -- test (change)
                ["steel"] = 1, -- test (change)
                ["rubber"] = 1, -- test (change)
            },
            type = "item",
            slot = 1,
            threshold = 0,
            points = 0,
        },
        [2] = {
            name = "pistol_suppressor",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 165,
                ["steel"] = 285,
                ["rubber"] = 20,
            },
            type = "item",
            slot = 2,
            threshold = 0,
            points = 0,
        },
        [3] = {
            name = "pistol_suppressor",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 165,
                ["steel"] = 285,
                ["rubber"] = 20,
            },
            type = "item",
            slot = 3,
            threshold = 0,
            points = 0,
        },
    }
}

Config.CraftingItems = {
    [1] = {
        name = "lockpick",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 22,
            ["plastic"] = 32,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },
    [2] = {
        name = "screwdriverset",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 30,
            ["plastic"] = 42,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 2,
    },
    [3] = {
        name = "electronickit",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 30,
            ["plastic"] = 45,
            ["aluminum"] = 28,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 3,
    },
}