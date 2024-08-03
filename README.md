# Global Positioning Scrambler

Do you hate having accurate positioning
and find a gps constellation to complicated or expensive for your needs?

Then I've got the solution for you: GPS

## Usage
```
> gps scramble
```
or
```
> gps scramble <x> <y> <z>
```

## Native gps

The old gps program is the fallback when not specifing `scramble`
as the second argument

## Circumvention

If somebody is messing with you using this script, then first of all:
I apologize\*

You can circumvent this by changing `gps.CHANNEL_GPS` on all your computers
*and* on the ones hosting the gps to something different.
To do this use add the following to `/startup.lua`:
```lua
gps.CHANNEL_GPS = <your-new-number>
```

\* Excpet if it was me

## Contributions

This was only designed as a quick test.
I will not develop this any further.
Feel free to maintain a fork.
