use v6;
# perl6 scripts to get page not translated.

my @dir_cn = dir('../pages', test => /\.tt$/) ;
my @dir_en = dir('../../en/pages', test => /\.tt$/) ;
my @dir_cn_draft = dir('../drafts', test => /\.tt$/) ;
my @l = ((@dir_en (-) @dir_cn ) (-) @dir_cn_draft).list;

@l>>.say;
@l.elems.say;


