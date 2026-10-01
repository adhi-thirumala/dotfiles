return {
    'dmtrKovalenko/fff',
    build = function()
        require('fff.download').download_or_build_binary()
    end,
    opts = {},
    lazy = false, -- background indexer + frecency warm-up need startup load
    keys = {
        { '<Leader><Leader>', function() require('fff').find_files() end, desc = 'Find Files' },
        { '<Leader>g',        function() require('fff').live_grep() end,  desc = 'Live Grep' },
    },
}

