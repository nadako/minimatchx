import minimatchx.Minimatch;

class Patterns {
	static public var files = [
		'a', 'b', 'c', 'd', 'abc',
		'abd', 'abe', 'bb', 'bcd',
		'ca', 'cb', 'dd', 'de',
		'bdir/', 'bdir/cfile'
	];

	static function item(pattern:String, expect:Array<String>, ?options:MinimatchOptions, ?files:Array<String>, ?assertOpts:Dynamic) {
		return {
			pattern: pattern,
			expect: expect,
			options: options,
			files: files,
			assertOpts: assertOpts,
		};
	}

	static public var patterns:Array<{
		info:String,
		?files:Array<String>,
		items:Array<{
			pattern:String,
			expect:Array<String>,
			options:Null<MinimatchOptions>,
			files:Null<Array<String>>,
			assertOpts:Null<Dynamic>
		}>
	}> = [
		{
			info: 'http://www.bashcookbook.com/bashinfo/source/bash-1.14.7/tests/glob-test',
			items: [
				item('a*', ['a', 'abc', 'abd', 'abe']),
				item('X*', ['X*'], {nonull: true}),

				// allow null glob expansion
				item('X*', []),

				// isaacs: Slightly different than bash/sh/ksh
				// \\* is not un-escaped to literal "*" in a failed match,
				// but it does make it get treated as a literal star
				item('\\*', ['\\*'], {nonull: true}),
				item('\\**', ['\\**'], {nonull: true}),
				item('\\*\\*', ['\\*\\*'], {nonull: true}),

				item('b*/', ['bdir/']),
				item('c*', ['c', 'ca', 'cb']),
				item('**', files),

				item('\\.\\./*/', ['\\.\\./*/'], {nonull: true}),
				item('s/\\..*//', ['s/\\..*//'], {nonull: true}),
			]
		},
		{
			info: 'legendary larry crashes bashes',
			items: [
				item("/^root:/{s/^[^:]*:[^:]*:([^:]*).*$/\\1/", ["/^root:/{s/^[^:]*:[^:]*:([^:]*).*$/\\1/"], {nonull: true}),
				item("/^root:/{s/^[^:]*:[^:]*:([^:]*).*$/\u0001/", ["/^root:/{s/^[^:]*:[^:]*:([^:]*).*$/\u0001/"], {nonull: true}),
			]
		},
		{
			info: 'character classes',
			items: [
				item('[a-c]b*', ['abc', 'abd', 'abe', 'bb', 'cb']),
				item('[a-y]*[^c]', ['abd', 'abe', 'bb', 'bcd', 'bdir/', 'ca', 'cb', 'dd', 'de']),
				item('a*[^c]', ['abd', 'abe']),
				item('a[X-]b', ['a-b', 'aXb'], null, files.concat(['a-b', 'aXb'])),
				item('[^a-c]*', ['d', 'dd', 'de'], null, files.concat(['a-b', 'aXb', '.x', '.y'])),
				item('a\\*b/*', ['a*b/ooo'], null, files.concat(['a-b', 'aXb', '.x', '.y', 'a*b/', 'a*b/ooo'])),
				item('a\\*?/*', ['a*b/ooo'], null, files.concat(['a-b', 'aXb', '.x', '.y', 'a*b/', 'a*b/ooo'])),
				item('*\\\\!*', [], null, ['echo !7']),
				item('*\\!*', ['echo !7'], null, ['echo !7']),
				item('*.\\*', ['r.*'], null, ['r.*']),
				item('a[b]c', ['abc'], null, files.concat(['a-b', 'aXb', '.x', '.y', 'a*b/', 'a*b/ooo'])),
				item('a[\\b]c', ['abc'], null, files.concat(['a-b', 'aXb', '.x', '.y', 'a*b/', 'a*b/ooo'])),
				item('a?c', ['abc'], null, files.concat(['a-b', 'aXb', '.x', '.y', 'a*b/', 'a*b/ooo'])),
				item('a\\*c', [], null, ['abc']),
				item('', [''], null, ['']),
			]
		},
		{
			info: 'http://www.opensource.apple.com/source/bash/bash-23/bash/tests/glob-test',
			files: files.concat(['man/', 'man/man1/', 'man/man1/bash.1']),
			items: [
				item('*/man*/bash.*', ['man/man1/bash.1']),
				item('man/man1/bash.1', ['man/man1/bash.1']),
				item('a***c', ['abc'], null, ['abc']),
				item('a*****?c', ['abc'], null, ['abc']),
				item('?*****??', ['abc'], null, ['abc']),
				item('*****??', ['abc'], null, ['abc']),
				item('?*****?c', ['abc'], null, ['abc']),
				item('?***?****c', ['abc'], null, ['abc']),
				item('?***?****?', ['abc'], null, ['abc']),
				item('?***?****', ['abc'], null, ['abc']),
				item('*******c', ['abc'], null, ['abc']),
				item('*******?', ['abc'], null, ['abc']),
				item('a*cd**?**??k', ['abcdecdhjk'], null, ['abcdecdhjk']),
				item('a**?**cd**?**??k', ['abcdecdhjk'], null, ['abcdecdhjk']),
				item('a**?**cd**?**??k***', ['abcdecdhjk'], null, ['abcdecdhjk']),
				item('a**?**cd**?**??***k', ['abcdecdhjk'], null, ['abcdecdhjk']),
				item('a**?**cd**?**??***k**', ['abcdecdhjk'], null, ['abcdecdhjk']),
				item('a****c**?**??*****', ['abcdecdhjk'], null, ['abcdecdhjk']),
				item('[-abc]', ['-'], null, ['-']),
				item('[abc-]', ['-'], null, ['-']),
				item('\\', ['\\'], null, ['\\']),
				item('[\\\\]', ['\\'], null, ['\\']),
				item('[[]', ['['], null, ['[']),
				item('[', ['['], null, ['[']),
				item('[*', ['[abc'], null, ['[abc']),
			]
		},
		// {
		// 	info: ,
		// 	items: [
		// 		
		// 	]
		// },
		// {
		// 	info: ,
		// 	items: [
		// 		
		// 	]
		// },
	];

	static public var regexps = [
		"/^(?:(?=.)a[^/]*?)$/",
		"/^(?:(?=.)X[^/]*?)$/",
		"/^(?:(?=.)X[^/]*?)$/",
		"/^(?:\\*)$/",
		"/^(?:(?=.)\\*[^/]*?)$/",
		"/^(?:\\*\\*)$/",
		"/^(?:(?=.)b[^/]*?\\/)$/",
		"/^(?:(?=.)c[^/]*?)$/",
		"/^(?:(?:(?!(?:\\/|^)\\.).)*?)$/",
		"/^(?:\\.\\.\\/(?!\\.)(?=.)[^/]*?\\/)$/",
		"/^(?:s\\/(?=.)\\.\\.[^/]*?\\/)$/",
		"/^(?:\\/\\^root:\\/\\{s\\/(?=.)\\^[^:][^/]*?:[^:][^/]*?:\\([^:]\\)[^/]*?\\.[^/]*?\\$\\/1\\/)$/",
		"/^(?:\\/\\^root:\\/\\{s\\/(?=.)\\^[^:][^/]*?:[^:][^/]*?:\\([^:]\\)[^/]*?\\.[^/]*?\\$\\/\u0001\\/)$/",
		"/^(?:(?!\\.)(?=.)[a-c]b[^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[a-y][^/]*?[^c])$/",
		"/^(?:(?=.)a[^/]*?[^c])$/",
		"/^(?:(?=.)a[X-]b)$/",
		"/^(?:(?!\\.)(?=.)[^a-c][^/]*?)$/",
		"/^(?:a\\*b\\/(?!\\.)(?=.)[^/]*?)$/",
		"/^(?:(?=.)a\\*[^/]\\/(?!\\.)(?=.)[^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?\\\\\\![^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?\\![^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?\\.\\*)$/",
		"/^(?:(?=.)a[b]c)$/",
		"/^(?:(?=.)a[b]c)$/",
		"/^(?:(?=.)a[^/]c)$/",
		"/^(?:a\\*c)$/",
		"false",
		"/^(?:(?!\\.)(?=.)[^/]*?\\/(?=.)man[^/]*?\\/(?=.)bash\\.[^/]*?)$/",
		"/^(?:man\\/man1\\/bash\\.1)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/]*?c)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]c)$/",
		"/^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/])$/",
		"/^(?:(?!\\.)(?=.)[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/])$/",
		"/^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]c)$/",
		"/^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?c)$/",
		"/^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/])$/",
		"/^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?c)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/])$/",
		"/^(?:(?=.)a[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/]k)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/]k)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/]k[^/]*?[^/]*?[^/]*?)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/][^/]*?[^/]*?[^/]*?k)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/][^/]*?[^/]*?cd[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/][^/]*?[^/]*?[^/]*?k[^/]*?[^/]*?)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?c[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[-abc])$/",
		"/^(?:(?!\\.)(?=.)[abc-])$/",
		"/^(?:\\\\)$/",
		"/^(?:(?!\\.)(?=.)[\\\\])$/",
		"/^(?:(?!\\.)(?=.)[\\[])$/",
		"/^(?:\\[)$/",
		"/^(?:(?=.)\\[(?!\\.)(?=.)[^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[\\]])$/",
		"/^(?:(?!\\.)(?=.)[\\]-])$/",
		"/^(?:(?!\\.)(?=.)[a-z])$/",
		"/^(?:(?!\\.)(?=.)[^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/])$/",
		"/^(?:(?!\\.)(?=.)[^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?c)$/",
		"/^(?:(?!\\.)(?=.)[^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?c[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/]*?[^/]*?[^/]*?[^/]*?)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?c[^/]*?[^/][^/]*?[^/]*?)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?c[^/]*?[^/][^/]*?[^/]*?)$/",
		"/^(?:(?=.)a[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/][^/][^/][^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?[^/]*?)$/",
		"/^(?:\\[\\])$/",
		"/^(?:\\[abc)$/",
		"/^(?:(?=.)XYZ)$/i",
		"/^(?:(?=.)ab[^/]*?)$/i",
		"/^(?:(?!\\.)(?=.)[ia][^/][ck])$/i",
		"/^(?:\\/(?!\\.)(?=.)[^/]*?|(?!\\.)(?=.)[^/]*?)$/",
		"/^(?:\\/(?!\\.)(?=.)[^/]|(?!\\.)(?=.)[^/]*?)$/",
		"/^(?:(?:(?!(?:\\/|^)\\.).)*?)$/",
		"/^(?:a\\/(?!(?:^|\\/)\\.{1,2}(?:$|\\/))(?=.)[^/]*?\\/b)$/",
		"/^(?:a\\/(?=.)\\.[^/]*?\\/b)$/",
		"/^(?:a\\/(?!\\.)(?=.)[^/]*?\\/b)$/",
		"/^(?:a\\/(?=.)\\.[^/]*?\\/b)$/",
		"/^(?:(?:(?!(?:\\/|^)(?:\\.{1,2})($|\\/)).)*?)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?\\(a\\/b\\))$/",
		"/^(?:(?!\\.)(?=.)(?:a|b)*|(?!\\.)(?=.)(?:a|c)*)$/",
		"/^(?:(?=.)\\[(?=.)\\!a[^/]*?)$/",
		"/^(?:(?=.)\\[(?=.)#a[^/]*?)$/",
		"/^(?:(?=.)\\+\\(a\\|[^/]*?\\|c\\\\\\\\\\|d\\\\\\\\\\|e\\\\\\\\\\\\\\\\\\|f\\\\\\\\\\\\\\\\\\|g)$/",
		"/^(?:(?!\\.)(?=.)(?:a|b)*|(?!\\.)(?=.)(?:a|c)*)$/",
		"/^(?:a|(?!\\.)(?=.)[^/]*?\\(b\\|c|d\\))$/",
		"/^(?:a|(?!\\.)(?=.)(?:b|c)*|(?!\\.)(?=.)(?:b|d)*)$/",
		"/^(?:(?!\\.)(?=.)(?:a|b|c)*|(?!\\.)(?=.)(?:a|c)*)$/",
		"/^(?:(?!\\.)(?=.)[^/]*?\\(a\\|b\\|c\\)|(?!\\.)(?=.)[^/]*?\\(a\\|c\\))$/",
		"/^(?:(?=.)a[^/]b)$/",
		"/^(?:(?=.)#[^/]*?)$/",
		"/^(?!^(?:(?=.)a[^/]*?)$).*$/",
		"/^(?:(?=.)\\!a[^/]*?)$/",
		"/^(?:(?=.)a[^/]*?)$/",
		"/^(?!^(?:(?=.)\\!a[^/]*?)$).*$/",
		"/^(?:(?!\\.)(?=.)[^\\/]*?\\.(?:(?!(?:js)$)[^\\/]*?))$/",
		"/^(?:(?:(?!(?:\\/|^)\\.).)*?\\/\\.x\\/(?:(?!(?:\\/|^)\\.).)*?)$/",
		"/^(?:\\[z\\-a\\])$/",
		"/^(?:a\\/\\[2015\\-03\\-10T00:23:08\\.647Z\\]\\/z)$/",
		"/^(?:(?=.)\\[a-0\\][a-Ā])$/",
	];
}