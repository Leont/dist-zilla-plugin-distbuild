#! perl
use strict;
use warnings FATAL => 'all';

use CPAN::Meta;
use Path::Tiny;
use Test::More;
use Test::DZil;
use Module::Metadata;

my $tzil = Builder->from_config(
	{ dist_root => 't/does_not_exist' },
	{
		add_files => {
			'source/dist.ini' => simple_ini(
				[ DistBuild => ],
				[ Prereqs => 'RuntimeRequires' => { perl => '5.008' } ],
				[ Prereqs => 'BuildRequires' => { perl => '5.010' } ],
			),
		},
	},
);
$tzil->build;

my $VERSION = Dist::Zilla::Plugin::DistBuild->VERSION || '<self>';
my $expected = <<"END";
# This Build.PL for DZT-Sample was generated by Dist::Zilla::Plugin::DistBuild $VERSION.
use strict;
use warnings;


use 5.010;
use Dist::Build 0.001;
Build_PL(\\\@ARGV, \\\%ENV);

END

is(path($tzil->built_in)->child('Build.PL')->slurp, $expected, 'Build.PL declares the correct minimum perl version');

done_testing;
# vim: set ts=4 sw=4 noet nolist :
