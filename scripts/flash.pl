#!/usr/bin/perl -w

use lib `fvwm-perllib dir`;
use FVWM::Module;

my $module = new FVWM::Module(
    Mask => M_NEW_PAGE | M_NEW_DESK,
    Debug => 1,
);

sub got_new_page {
    my ($module, $event) = @_;


    my $width  = $event->_vp_width;
    my $height = $event->_vp_height;

    if (!$width || !$height) {
        # this may happen when doing DeskTopSize 1x1 on page 2 2
        return;
    }

    my $page_nx = int($event->_vp_x / $width) + 1;
    my $page_ny = int($event->_vp_y / $height) + 1;

    # actually show the flash
    $module->send("Exec xmessage -name FlashWindow -bg black -fg white -center -timeout 1 -button '' -xrm '*cursorName: none' -xrm '*borderWidth: 2' -xrm '*borderColor: yellow' -xrm '*Margin: 12' '($page_ny, $page_nx)'");
    $module->send("Style FlashWindow StaysOnTop, NoTitle, NoHandles, BorderWidth 5, WindowListSkip, NeverFocus, UsePPosition");
}

$module->add_handler(M_NEW_PAGE, \&got_new_page);

$module->event_loop;
