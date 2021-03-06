//
//  PTKeyCodeTranslator.m
//  Chercher
//
//  Created by Finlay Dobbie on Sat Oct 11 2003.
//  Copyright (c) 2003 Cliché Software. All rights reserved.
//

#import "PTKeyCodeTranslator.h"


@implementation PTKeyCodeTranslator

+ (id)currentTranslator
{
    static PTKeyCodeTranslator *current = nil;
    TISInputSourceRef currentLayout = TISCopyCurrentKeyboardLayoutInputSource();
    
    if (current == nil) {
        current = [[PTKeyCodeTranslator alloc] initWithKeyboardLayout:currentLayout];
    } else if ([current keyboardLayout] != currentLayout) {
        [current release];
        current = [[PTKeyCodeTranslator alloc] initWithKeyboardLayout:currentLayout];
    }
    return current;
}

- (id)initWithKeyboardLayout:(TISInputSourceRef)aLayout
{
    if ((self = [super init]) != nil) {
        
        keyboardLayout = aLayout;
        CFDataRef uchr = TISGetInputSourceProperty( keyboardLayout , kTISPropertyUnicodeKeyLayoutData );
        uchrData = ( const UCKeyboardLayout* )CFDataGetBytePtr(uchr);
        
    }
    
    return self;
}

- (NSString *)translateKeyCode:(short)keyCode {
    UniCharCount maxStringLength = 4, actualStringLength;
    UniChar unicodeString[4];
    OSStatus err;
    err = UCKeyTranslate( uchrData, keyCode, kUCKeyActionDisplay, 0, LMGetKbdType(), kUCKeyTranslateNoDeadKeysBit, &deadKeyState, maxStringLength, &actualStringLength, unicodeString );
    return [NSString stringWithCharacters:unicodeString length:1];
}

- (TISInputSourceRef)keyboardLayout {
    return keyboardLayout;
}

- (NSString *)description {
    NSString *kind = @"uchr";
    
    NSString *layoutName = TISGetInputSourceProperty( keyboardLayout, kTISPropertyLocalizedName );
    return [NSString stringWithFormat:@"PTKeyCodeTranslator layout=%@ (%@)", layoutName, kind];
}

@end
