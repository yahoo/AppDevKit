//
//  UIColor+ADKHexPresentationSpec.m
//  AppDevKit
//
//  Created by Jeff Lin on 6/8/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <kiwi/kiwi.h>
#import "UIColor+ADKHexPresentation.h"

SPEC_BEGIN(ADKHexPresentationSpec)

describe(@"Test ADKColorWithHexRed:green:blue:alpha", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexRed:0x7b green:0x00 blue:0x99 alpha:1.0f];
        [[testColor should] equal:expectedColor];
    });
});

describe(@"Test ADKInitWithHexRed:green:blue:alpha", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [[UIColor alloc] ADKInitWithHexRed:0x7b green:0x00 blue:0x99 alpha:1.0f];
        [[testColor should] equal:expectedColor];
    });
});

describe(@"Test ADKColorWithHexString:", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexString:@"7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with #7b0099, expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexString:@"#7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with 0x7b0099, expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexString:@"0x7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with 0X7b0099, expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexString:@"0X7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with 709, expect color should be 770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexString:@"709"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with #709, expect color should be 770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexString:@"#709"];
        [[testColor should] equal:expectedColor];
    });
});

describe(@"Test ADKColorWithHexString:alpha:", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:0.5f];
        UIColor *testColor = [UIColor ADKColorWithHexString:@"7b0099" alpha:0.5f];
        [[testColor should] equal:expectedColor];
    });
});

describe(@"Test ADKInitWithHexString:", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [[UIColor alloc] ADKInitWithHexString:@"7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with #7b0099, expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [[UIColor alloc] ADKInitWithHexString:@"#7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with 0x7b0099, expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [[UIColor alloc] ADKInitWithHexString:@"0x7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with 0X7b0099, expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [[UIColor alloc] ADKInitWithHexString:@"0X7b0099"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with 709, expect color should be 770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [[UIColor alloc] ADKInitWithHexString:@"709"];
        [[testColor should] equal:expectedColor];
    });

    it(@"given color with #709, expect color should be 770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [[UIColor alloc] ADKInitWithHexString:@"#709"];
        [[testColor should] equal:expectedColor];
    });
});

describe(@"Test ADKColorWithHexNumber:", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        UIColor *testColor = [UIColor ADKColorWithHexNumber:0x7b0099];
        [[testColor should] equal:expectedColor];
    });
});

describe(@"Test ADKColorShiftBySaturation:", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithHue:0.8f saturation:1.0f brightness:0.6f alpha:1.0f];
        UIColor *testColor = [[UIColor colorWithHue:0.8f saturation:0.5f brightness:0.6f alpha:1.0f] ADKColorShiftBySaturation:0.5f];
        [[testColor should] equal:expectedColor];
    });
});

describe(@"Test ADKHexString", ^{
    it(@"given color with 7b0099, should get string 7B0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        [[[expectedColor ADKHexString] should] equal:@"7B0099"];
    });
});

describe(@"Test ADKColorWithRGBHexString", ^{
    it(@"expect color should be 7b0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        [[[UIColor ADKColorWithRGBHexString:@"7B0099"] should] equal:expectedColor];
    });

    it(@"given color with 709, expect color should be 770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        [[[UIColor ADKColorWithRGBHexString:@"709"] should] equal:expectedColor];
    });

    it(@"given color with #709, expect color should be 770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0 / 255.0f blue:153.0f / 255.0f alpha:1.0f];
        [[[UIColor ADKColorWithRGBHexString:@"#709"] should] equal:expectedColor];
    });
});

describe(@"Test ADKColorWithARGBHexString", ^{
    it(@"expect color should be EE7B0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:238.0f / 255.0f];
        [[[UIColor ADKColorWithARGBHexString:@"EE7B0099"] should] equal:expectedColor];
    });

    it(@"given color with 7B0099, expect color should be FF7B0099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:255.0f / 255.0f];
        [[[UIColor ADKColorWithARGBHexString:@"7B0099"] should] equal:expectedColor];
    });

    it(@"given color with E709, expect color should be EE770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:238.0f / 255.0f];
        [[[UIColor ADKColorWithARGBHexString:@"E709"] should] equal:expectedColor];
    });

    it(@"given color with 709, expect color should be FF770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:255.0f / 255.0f];
        [[[UIColor ADKColorWithARGBHexString:@"709"] should] equal:expectedColor];
    });

    it(@"given color with #709, expect color should be FF770099", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:255.0f / 255.0f];
        [[[UIColor ADKColorWithARGBHexString:@"#709"] should] equal:expectedColor];
    });
});

describe(@"Test ADKColorWithRGBAHexString", ^{
    it(@"expect color should be 7B0099EE", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:238.0f / 255.0f];
        [[[UIColor ADKColorWithRGBAHexString:@"7B0099EE"] should] equal:expectedColor];
    });

    it(@"given color with 7B0099, expect color should be 7B0099FF", ^{
        UIColor *expectedColor = [UIColor colorWithRed:123.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:255.0f / 255.0f];
        [[[UIColor ADKColorWithRGBAHexString:@"7B0099"] should] equal:expectedColor];
    });

    it(@"given color with 709E, expect color should be 770099EE", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:238.0f / 255.0f];
        [[[UIColor ADKColorWithRGBAHexString:@"709E"] should] equal:expectedColor];
    });

    it(@"given color with 709, expect color should be 770099FF", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:255.0f / 255.0f];
        [[[UIColor ADKColorWithRGBAHexString:@"709"] should] equal:expectedColor];
    });

    it(@"given color with #709, expect color should be 770099FF", ^{
        UIColor *expectedColor = [UIColor colorWithRed:119.0f / 255.0f green:0.0f / 255.0f blue:153.0f / 255.0f alpha:255.0f / 255.0f];
        [[[UIColor ADKColorWithRGBAHexString:@"#709"] should] equal:expectedColor];
    });
});

SPEC_END
