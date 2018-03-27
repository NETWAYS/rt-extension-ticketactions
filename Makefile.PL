use inc::Module::Install;

RTx     'RT-Extension-TicketActions';
license 'gpl_2';
repository 'https://github.com/NETWAYS/rt-extension-ticketactions';
readme_from 'lib/RT/Extension/TicketActions.pm';

requires_rt '4.4.2';
requires 'Date::Holidays' => '1.07';

sign;
WriteAll;
