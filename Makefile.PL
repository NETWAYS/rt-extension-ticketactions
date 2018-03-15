use strict;
use inc::Module::Install;

RTx('RT-Extension-TicketActions');
author('Marius Hein <marius.hein@netways.de>');
version('1.0');
license('gpl');
readme_from('lib/RT/Extension/TicketActions.pm');

&WriteAll;

