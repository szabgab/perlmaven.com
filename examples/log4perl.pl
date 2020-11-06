use Log::Log4perl ();

Log::Log4perl->easy_init( {
            level    => 'INFO',
            layout   => '%d{yyyy-MM-dd HH:mm:ss} - %p - %F{1}-%L-%M - %m%n',
            # file     => ">test.log",
            # utf8     => 1,
            # category => "Bar::Twix",
});

my $logger = Log::Log4perl->get_logger();

$logger->debug("This is debug");
$logger->info("This is info");
