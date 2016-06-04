package MyTree;
use strict;
use warnings;

sub good_cases {
	return (
		[
			{
				id => 1,
				payload => 'foo',
			}
		],
		[
			{
				id => 2,
				payload => 'foo',
			},
			{
				id => 3,
				payload => 'bar',
				subtree => [
					{
						id => 4,
						payload => 'abc',
						subtree => [
							{
								id => 6,
								payload => 'third',
							}
						],
					},
					{
						id => 5,
						payload => 'def',
					}
				]
			}
		],
	);
}

sub bad_cases {
	return (
		[
			{
				id => 21,
				payload => 'foo',
				other => 'value',
			},
		],
		[
			{
				id => 21,
				payload => 'foo',
				other => 'value',
			},
			'somethig else',
		],
		[
			{
				id => 22,
			}
		],
		[
			{
				id => 2,
				payload => 'foo',
			},
			{
				id => 3,
				payload => 'bar',
				subtree => [
					{
						id => 4,
						payload => 'abc',
						extra => 'value',
						subtree => [
							{
								id => 6,
								payload => 'third',
							}
						],
					},
					{
						id => 5,
						payload => 'def',
					}
				]
			}
		],
		[
			{
				id => 2,
				payload => 'foo',
			},
			{
				id => 3,
				payload => 'bar',
				subtree => [
					{
						id => 4,
						subtree => [
							{
								id => 6,
								payload => 'third',
							}
						],
					},
					{
						id => 5,
						payload => 'def',
					}
				]
			}
		],
		[
			{
				id => 2,
				payload => 'foo',
			},
			{
				id => 3,
				payload => 'bar',
				subtree => [
					{
						id => 4,
						payload => 'abc',
						subtree => [
							{
								id => 6,
								payload => 'third',
								extra => 'val',
							}
						],
					},
					{
						id => 5,
						payload => 'def',
					}
				]
			}
		],
		[
			{
				id => 2,
				payload => 'foo',
			},
			{
				id => 3,
				payload => 'bar',
				subtree => [
					{
						id => 4,
						payload => 'abc',
						subtree => [
							{
								id => 6,
							}
						],
					},
					{
						id => 5,
						payload => 'def',
					}
				]
			}
		],
	);
}

1;



