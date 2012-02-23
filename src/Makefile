CC=/Developer4/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc
CFLAGS=-arch armv6 -Wall -O2 -fconstant-cfstrings -std=gnu99 -isysroot /Developer4/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk -I/Developer4/Platforms/iPhoneOS.platform/Developer/usr/include/gcc/darwin/default -I/Developer4/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/usr/lib/gcc/arm-apple-darwin9/4.0.1/include -F/Developer4/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/PrivateFrameworks -I_fallback 
-x objective-c++ -miphoneos-version-min=3.2


LD=$(CC)
#LDFLAGS=-lobjc -dynamiclib -bind_at_load -F"/System/Library/PrivateFrameworks"  -framework UIKit -framework CoreFoundation -framework Foundation -framework SystemConfiguration -framework QuartzCore
LDFLAGS=-lobjc -dynamiclib -bind_at_load -F/Developer4/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS3.2.sdk/System/Library/PrivateFrameworks -framework UIKit -framework CoreFoundation -framework Foundation -framework SystemConfiguration -framework CoreGraphics -framework CFNetwork -l xml2


#CFLAGS=-fconstant-cfstrings -std=gnu99 -Wall -O2 -I/var/include -I..
VERSION=1.0

all:    Toggle.dylib

Toggle.dylib: main.o DictImpl.o
	$(LD) $(CFLAGS) $(LDFLAGS) -o $@ $^
	ldid -S Toggle.dylib

%.o: %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
	   
%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
	rm -f *.o edge
