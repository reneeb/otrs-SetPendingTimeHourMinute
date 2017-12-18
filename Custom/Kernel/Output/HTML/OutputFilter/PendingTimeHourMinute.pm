# --
# Copyright (C) 2015 - 2017 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilter::PendingTimeHourMinute;

use strict;
use warnings;

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Web::Request
    Kernel::System::Ticket
    Kernel::Output::HTML::Layout
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{UserID} = $Param{UserID};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get template name
    my $Templatename = $Param{TemplateFile} || '';
    return 1 if !$Templatename;
    return 1 if !$Param{Templates}->{$Templatename};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Hour         = $ConfigObject->Get('SetPendingTimeHourMinute::DefaultPendingHour');
    my $Minute       = $ConfigObject->Get('SetPendingTimeHourMinute::DefaultPendingMinute');

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->AddJSOnDocumentComplete( Code => qq~
        <script type="text/javascript">//<![CDATA[
            \$('#Hour').val( $Hour );
            \$('#Minute').val( $Minute );
        //]]></script>~
    );

    return 1;
}

1;
