return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
		},
	},
	opts = {
		pickers = {},
		extensions = {},
    },
    keys = {
        { '<Leader><Leader>', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
        { '<C-A-b>',          function() require('telescope.builtin').buffers() end,    desc = 'Buffers' },
        {
            '<leader><C-Space>',
            function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true }) end,
            desc = 'Find all files (ignore gitignore)',
        },
    },
}
